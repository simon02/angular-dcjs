#Angular DcJS Prototype
This app uses the Yeoman Angular Generator from https://www.npmjs.org/package/generator-angularseed

## Usage:
After you installed the dependencies, you can:

Run application (prepare files and start a server), 
at the applciation path ./angular-dcjs
>grunt server --force

Run Unit Tests,
at the applciation path ./angular-dcjs
>grunt test --force

* --force in case not all packages are installed.

### This app's requirements

#### Step 1. Set up your Environment, for Yeoman newbies

NodeJS, Yeoman (Yo , Grunt &  Bower), Compass - a Ruby gem

*Nodejs

http://nodejs.org/download/

...Or on OSX homebrew
>brew install node

*Compass - Optional module for Sass

update your Ruby gem app and repo.
>gem update --system

Must install Sass First Since Compass is asking for a version os sass which doesn't work.
>sudo gem install sass
>sudo gem install compass

*Yeoman - the node package manager should fetch its dependencies Bower and Grunt.
>npm install -g yo

In case you have issues you can install Bower and Grunt
>sudo npm install -g bower

>sudo npm install -g grunt-cli


#### Step 2. Install the application-specific dependencies

Go to the application root ./angular-dcjs
>bower install

>npm install

### Dependency maintenance:
To add new dependencies to the project, run "bower YOUR DEPENDENCY --save-dev".

### Starting Application
To start the app
>grunt server

Or if you want to start the server using the distribution package
>grunt server:dist

### Generating a Distribution Package
Use the command
>grunt build

A "dist" folder will be created in your root folder of the project

