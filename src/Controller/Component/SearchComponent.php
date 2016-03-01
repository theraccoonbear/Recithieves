<?php

namespace App\Controller\Component;

use Cake\Controller\Component;
use Goutte\Client;

class SearchComponent extends Component
{
    public $client;
    
    public static $units_map = [
        "cups?" => "c.",
        "c\\.?" => "c.",
        "tablespoons?" => "T.",
        "tbsp" => "T.",
        "TBSP\\.?" => "T.",
        "T\\.?" => "T.",
        "teaspoons?" => "t.",
        "tsp" => "t.",
        "t\\.?" => "t.",
        "ounces?" => "oz.",
        "ozs?\\.?" => "oz.",
        "(fl\\.?|fluid)\\s+(ounces?|ozs?\\.?)" => "fl. oz.",
        "pints?" => "pt.",
        "pt\\.?" => "pt.",
        "quarts?" => "qt.",
        "qts?\\.?" => "qt.",
        "gallons?" => "gal.",
        "gals?\\.?" => "gal.",
        "pounds?" => "lbs.",
        "lbs?\\.?" => "lbs.",
        "packages?" => "pkg.",
        "pkg\\.?" => "pkg.",
        "liters?" => "L.",
        "L\\.?" => "L.",
        "m[lL]" => "mL",
        "[Dd]ash(es)?" => "dash",
        "[Pp]inch(es)?" => "pinch",
        "each" => "each"
    ];
    
    public function baseProto() {
        return 'http';
    }
    
    public function baseHost() {
        return 'food52.com';
    }
    
    public function baseURL() {
        return $this->baseProto() . '://' . $this->baseHost();
    }
    
    public function search($term, $using = []) {
        $this->client = new Client();
        $this->client->setServerParameters([
            'Referer' => $this->baseURL()
        ]);
        $crawler = $this->client->request('GET', $this->baseURL() . '/recipes/search?q=' . urlencode($term));
        $res = $crawler->filter('.recipe-results-tiles .collectable-tile')->each(function($node) {
            $photo_a = $node->filter('a.photo');
            $href = $photo_a->extract('href')[0];
            $img = $photo_a->filter('img');
            $fav = $node->filter('span.counter');
            $img_url = $img->extract('src')[0];
            
            if (preg_match('/^\/\//', $img_url)) {
                $img_url = $this->baseProto() . ':' . $img_url;
            } else {
                $img_url = $this->baseURL() . $img_url;
            }
            
            
            
            return [
                'id' => $node->extract('data-id')[0],
                'title' => $img->extract('alt')[0],
                'url' => $this->baseURL() . $href,
                'image' => $img_url,
                'favorite' => 1 * preg_replace('/[^\d]+/', '', $fav->text())
            ];
        });
        
        //exit(0);
        //$res = [json_encode($this->client];
        return $res;
    }
    
    public static function cleanStr($str) {
        return preg_replace('/^\s+/', '', preg_replace('/\s+$/', '', preg_replace('/\s+/', ' ', $str)));
    }
    
    public static function parseIngredient($ing) {
        $ing = SearchComponent::cleanStr($ing);
        $new_ing = $ing;
        
	
        $ing_rgx = '^(((<bqty>\d+)\s+)?(?<qty>(?<num>\d+)(\/(?<den>\d+))?)\s+)?(\b(?<unit>' . join('|', array_keys(SearchComponent::$units_map)) . ')\b\s+)?(?<name>.+)$';
	
        if (preg_match("/{$ing_rgx}/", $ing, $matches)) {
            $qty = $matches['qty'] ? ($matches['den'] ? $matches['num'] / $matches['den'] : $matches['qty']) : 1;
            $qty += array_key_exists('bqty', $matches) ? $matches['bqty'] : 0;
            $name = $matches['name'];
            $found = false;
            $unit = array_key_exists('unit', $matches) ? $matches['unit'] : 'each';
            
            //sort { lc($a) cmp lc($b) }
            //$unit_rgx = join('|', array_keys($units));
            
            //foreach $r (keys %$units) {
            foreach (SearchComponent::$units_map as $r => $o) {
                if (preg_match("/^{$r}\$/", $unit)) {
                    $unit = $o;
                    $found = true;
                    break;
                }
            }
            
            if (!$found) { $unit = 'each'; }
            
            
            $new_ing = [
                'qty' => $qty,
                'unit' => $unit,
                'name' => $name
            ];
        }
	
        return $new_ing;
    }
    
    public function fetch($recipe_id) {
        $self =& $this;
        if (preg_match('/^\d+$/', $recipe_id)) {
            $recipe_id = $this->baseURL() . '/recipes/' . $recipe_id;
        }
        $this->client = new Client();
        $this->client->setServerParameters([
            'Referer' => $this->baseURL()
        ]);
        $crawler = $this->client->request('GET', $recipe_id);
        
        //$servings = $crawler->filter('p[itemprop="recipeYield"]');
        $ingredients = $crawler->filter('ul.recipe-list li')->each(function($ing) {
            return SearchComponent::parseIngredient($ing->text());
        });
        
        $directions = $crawler->filter('ol li[itemprop="recipeInstructions"]')->each(function($dir) {
           return preg_replace('/^\s+/', '', preg_replace('/\s+$/', '', preg_replace('/\s+/', ' ', $dir->text()))); 
        });
        
        
        
        $res = [
            'title' => $crawler->filter('h1.article-header-title')->text(),
            'author' => $crawler->filter('a[itemprop="author"]')->text(),
            'ingredients' => $ingredients,
            'directions' => $directions
        ];
        
        return $res;
    }
}