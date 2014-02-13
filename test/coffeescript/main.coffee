require.config
    baseUrl:  '../js'
    paths:
        test: '../test/javascript'
        specs: '../test/javascript/specs'

require ['test/speclist'], ->
    env = jasmine.getEnv()
    htmlReporter = new jasmine.HtmlReporter()
    window.consoleReporter = new jasmine.ConsoleReporter()

    if /PhantomJS/.test window.navigator.userAgent
        env.addReporter consoleReporter
    else
        env.addReporter(htmlReporter)

    env.specFilter = htmlReporter.specFilter
    env.execute()
