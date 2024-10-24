#!/usr/bin/env perl
use strict;
use warnings;
use File::Path qw(make_path);
use File::Spec;
use Config;

my $plenv_path = `which plenv`;
chomp $plenv_path;
if (!$plenv_path) {
    die "Error: plenv not found. Please install plenv and try again.\n";
}

my $perl_version = `plenv version-name`;
chomp $perl_version;
my $perl_path = `plenv which perl`;
chomp $perl_path;

if ($perl_path =~ m{^/usr/bin/perl}) {
    die "Error: It appears you're using system perl ($perl_path).\n" .
        "Please use plenv to set a different Perl version.\n"
}

my $project_name = shift @ARGV or die "Usage: $0 PROJECT_NAME\n";

# Print perl version and path for confirmation
print "Using Perl $perl_version at $perl_path\n";

# Create project directory
mkdir $project_name or die "Cannot create project directory: $!";
chdir $project_name or die "Cannot change to project directory: $!";

# Create basic directory structure
make_path('lib', 't', 'bin');

# Create basic module file
open my $module_fh, '>', "lib/$project_name.pm" or die "Cannot create module file: $!";
print $module_fh <<"EOT";
package $project_name;
use strict;
use warnings;

1;
EOT
close $module_fh;

# Create basic test file
open my $test_fh, '>', "t/01-basic.t" or die "Cannot create test file: $!";
print $test_fh <<"EOT";
use strict;
use warnings;
use Test::More;
use $project_name;

ok(1, 'Module loaded');
done_testing;
EOT
close $test_fh;

# Create a basic script file
open my $script_fh, '>', 'bin/main.pl' or die "Cannot create script file: $!"; 
print $script_fh <<"EOT";
#!/usr/bin/perl
use strict;
use warnings;
use lib 'lib';
use $project_name;

print "Hello from $project_name!\\n";
EOT
close $script_fh;

# Create cpanfile
open my $cpan_fh, '>', 'cpanfile' or die "Cannot create cpanfile: $!";
print $cpan_fh <<"EOT";
requires 'perl', '$]';
on test => sub {
    requires 'Test::More';
};
EOT
close $cpan_fh;

# Check if Carton is installed and install if necessary
my $carton_installed = system('plenv which carton >/dev/null 2>&1') == 0;
if (!$carton_installed) {
    print "Carton not found. Installing Carton...\n";
    system('plenv exec cspanm --install Carton') == 0
        or die "Failed to install Carton: $?";
}

print "Carton is available through plenv.\n";

# Initialize Carton
system('plenv exec carton install') == 0 or die "Failed to install dependencies: $?";

# Create run script
open my $run_fh, '>', 'run' or die "Cannot create run script: $!";
print $run_fh <<"EOT";
#!/bin/sh
if [ "\$1" = "test" ]; then
    shift
    exec plenv exec carton exec prove -l t "\$@"
else
    plenv exec carton exec perl -Ilib "\$@"
fi
EOT
close $run_fh;
chmod 0755, 'run' or die "Cannot make run script executabble: $!";

print "Project $project_name initialized with Carton.\n";
print "Use './run bin/main.pl' to run scripts with the correct environment.\n";
