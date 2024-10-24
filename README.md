# Perl Project Initializer

A script for quickly setting up new Perl projects with plenv and Carton.

## Prerequisites

- [plenv](https://github.com/tokuhirom/plenv)
- A Perl version installed via plenv
- [cpanm](https://metacpan.org/pod/App::cpanminus)

## Usage

1. Clone and enter the repository:
   ```
   git clone https://github.com/yourusername/perl-project-initializer.git
   cd perl-project-initializer
   ```

2. Make the script executable and run it:
   ```
   chmod +x perlinit.pl
   ./perlinit.pl MyNewProject
   ```

## Features

- Creates a basic Perl module structure (lib/, t/, bin/)
- Sets up Carton for dependency management
- Provides a `run` script for executing in the correct environment

## Project Structure
```
MyNewProject/
├── lib/MyNewProject.pm
├── t/01-basic.t
├── bin/main.pl
├── cpanfile
└── run
```

## Running Your Project
```
cd MyNewProject
./run bin/main.pl # Run main script
./run test # Run tests
```
## Contributing

Contributions are welcome. Please submit issues or pull requests.

