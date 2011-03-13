# StaticMatic: Build and Deploy

1: Build static websites using modern dynamic tools:

- [Haml](http://haml-lang.com/)
- [Sass](http://sass-lang.com/)
- [Coffeescript](http://jashkenas.github.com/coffee-script/)
- [Compass](compass-style.org)
- [Amazon S3 Websites](http://aws.typepad.com/aws/2011/02/host-your-static-website-on-amazon-s3.html)
- And more to come

2: Deploy to Amazon S3:

    $ staticmatic s3_deploy

3: Profit (due to low hosting fees :P)

## In other words:

                    StaticMatic build                   StaticMatic deploy
    src/                    ==>           build/                ==>           mywebsite.com/
      index.haml            ==>             index.html          ==>             index.html
      style.sass            ==>             style.css           ==>             style.css
      js/                   ==>             js/                 ==>             js/
        app.coffee          ==>               app.js            ==>               app.js
      img/                  ==>             img/                ==>             img/
        logo.png            ==>               logo.png          ==>               logo.png

# Getting Started

    $ gem install staticmatic2

## Quick Start

Instantly setup a new project:

    $ staticmatic init my-project

This will give you a basic skeleton:

    my-project/
      src/
        _layouts/
          default.haml
        _partials/
          example.haml
        index.haml

Preview your static website:

    $ cd my-project
    $ staticmatic preview
    Site root is: .
    StaticMatic Preview Server
    Ctrl+C to exit
    ...

Visit http://localhost:3000 to view your website in action.

To build & convert your haml/sass/whatever files into plain html, css, and javascript:

    $ staticmatic build
    
This will convert everything into a freshly generated `build/` folder, 100% static.

If you have an Amazon S3 account and want to deploy to your bucket, run the following command:

    # NOTE: You must be in the root folder of your project
    $ staticmatic s3_deploy

If you haven't deployed your current project to Amazon yet, it will prompt you to create a config file. Edit this file to include your credentials, run the command again, and you're set.

## Special Folders

    <my-project>/
      src/
        _helpers/
        _layouts/
        _partials/

- The `_helpers` folder is where you place your custom Haml helpers

- The `_layouts` folder is where layout files will be searched for. These files must contain a `yield` statement.

- The `_partials` folder is the last place partial files will be searched for. Any partial in this folder should not be prefixed with an underscore _

*USEFUL:* Any file or folder prefixed with an underscore _ will not be copied into the generated `site/` folder, nor will they be converted by haml, coffeescript, etc

## Partials

Partials are searched for in the following order:

- The file's current directory (the file must be prefixed with an underscore in this case)
- `src/_partials/`

Examples:

    # Searches for the default rendering engine file type
    = partial 'sidebar'
    
    # Equivalent to the above statement
    = partial 'sidebar.haml'
    
    # Directly inserts html file
    = partial 'help-content.html'
    
    # Use your own directory structure
    = partial 'blog-content/2011/vacation.html'

## Anti-Cache

Force the browser to ignore its cache whenever you damn well feel like it:

    # Creates a query string based on the current unix time
    stylesheets :menu, :form, :qstring => true
    
    <link href="/css/menu.css?_=1298789103" media="all" rel="stylesheet" type="text/css"/>
    <link href="/css/form.css?_=1298789103" media="all" rel="stylesheet" type="text/css"/>
    
    
    # Or, use your own qstring
    javascripts :app, :qstring => '2.0.6'

    <script language="javascript" src="js/app.js?_=2.0.6" type="text/javascript"></script>
