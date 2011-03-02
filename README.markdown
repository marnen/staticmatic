# StaticMatic

Build static websites using modern dynamic tools:

- [Haml](http://haml-lang.com/)
- [Sass](http://sass-lang.com/)
- [Coffeescript](http://jashkenas.github.com/coffee-script/)
- [Compass](compass-style.org)
- And more to come.

## Quick Start

Instantly setup a new project:

    $ staticmatic init my-project

Preview your static website:

    $ cd my-project
    $ staticmatic preview
    Site root is: .
    StaticMatic Preview Server
    Ctrl+C to exit
    ...

Visit http://localhost:3000 to view your website in action.

When you're ready to deploy, convert your haml/sass/whatever files into plain html, css, and javascript:

    staticmatic build
    
This will convert everything into a freshly generated `site/` folder.

## Where do I put my files?

Anywhere in your `src` folder. For example:

- `src/js/classes/Player.coffee` will be converted into `site/js/classes/Player.js`.
- `src/images/logo.png` will be directly copied into `site/images/logo.png`

However, there are a few (useful) exceptions:

## Special Folders

    <my-project>/
      src/
        _layouts/
        _partials/

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
