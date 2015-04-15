package API;

use Dancer ':syntax';
use FindBin;
use lib "$FindBin::Bin/../../lib";
use Data::Dumper;
use Data::Printer;
use File::Slurp;
use POSIX;
use JSON::XS;
#use Cwd 'abs_path';
#use File::Basename qw(dirname);

use Recithieves::Source::CooksIllustrated;
use Recithieves::Source::SeriousEats;

use Dancer::Plugin::Ajax;

#my $config_file = dirname(abs_path($0)) . "/../../config/config.json";
my $config_file = "../../config/config.json";

my $config = {};
my $script_started = time();

if ($config_file && -f $config_file) {
	my $file_data = read_file($config_file);
	$config = decode_json($file_data);
} else {
	die "No config file specified";
}

my $ci = new Recithieves::Source::CooksIllustrated(config => $config);
$ci->login();
my $se = new Recithieves::Source::SeriousEats(config => $config);

sub initRoutes {
	my $sources = {
		'cooks' => $ci,
		'serious-eats' => $se
	};

	any '/api/search/:source/:term' => sub {
		my $src = $sources->{param('source')};
		content_type 'text/plain';
		return encode_json($src->search(param('term')));

	};
	
	any '/api/fetch/:source/:id' => sub {
		my $src = $sources->{param('source')};
		content_type 'text/plain';
		return encode_json($src->getRecipe(param('id')));
	}
}

initRoutes();

true;
