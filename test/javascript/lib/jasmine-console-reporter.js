/**
 Jasmine Reporter that outputs test results to the browser console.
 Useful for running in a headless environment such as PhantomJs, ZombieJs etc.

 Usage:
 // From your html file that loads jasmine:
 jasmine.getEnv().addReporter(new jasmine.ConsoleReporter());
 jasmine.getEnv().execute();
 */

(function (jasmine, console) {
   if (!jasmine) {
      throw "jasmine library isn't loaded!";
   }

   var ANSI = {};
   ANSI.color_map = {
      "yellow":33,
      "green":32,
      "red":31
   };

   ANSI.colorize_text = function (text, color) {
      var color_code = this.color_map[color];
      return "\033[" + color_code + "m" + text + "\033[0m";
   };

   var ConsoleReporter = function () {
      if (!console || !console.log) {
         throw "console isn't present!";
      }
      this.status = this.statuses.stopped;
   };

   var proto = ConsoleReporter.prototype;
   proto.statuses = {
      stopped:"stopped",
      running:"running",
      fail:"fail",
      success:"success"
   };

   proto.reportRunnerStarting = function (runner) {
      this.status = this.statuses.running;
      this.start_time = (new Date()).getTime();
      this.executed_specs = 0;
      this.passed_specs = 0;
      this.skipped_specs = 0;
      this.suite_names = [];
      this.passed_spec_asserts = 0;
      this.log("");
      this.log("Starting...", "yellow");
      this.log("");
   };

   proto.reportRunnerResults = function (runner) {
      var failed = this.executed_specs - this.passed_specs;
      var suite_str = this.suite_names.length + (this.suite_names.length === 1 ? " suite, " : " suites, ");
      var spec_str = this.executed_specs + (this.executed_specs === 1 ? " spec, " : " specs, ");
      var passed_str = this.passed_spec_asserts + (this.passed_spec_asserts === 1 ? " passed assert, " : " passed asserts, ");
      var fail_str = failed + (failed === 1 ? " failure in " : " failures in ");
      var skipped_str = this.skipped_specs + (this.skipped_specs === 1 ? " spec skipped, " : " specs skipped, ");
      var color = (failed > 0) ? "red" : "green";
      var dur = (new Date()).getTime() - this.start_time;

      this.log("");
      this.log("Finished", "yellow");
      this.log("------------------------------------------------------------------------------");
      this.log(suite_str + spec_str + passed_str + fail_str + (dur / 1000) + "s.", color);

      this.status = (failed > 0) ? this.statuses.fail : this.statuses.success;

      /* Print something that signals that testing is over so that headless browsers
       like PhantomJs know when to terminate. */
      this.log("");
      this.log("ConsoleReporter finished");
   };


   function contains(a, obj) {
      var i = a.length;
      while (i--) {
         if (a[i] === obj) {
            return true;
         }
      }
      return false;
   }

   proto.reportSpecStarting = function (spec) {
      if (!contains(this.suite_names, spec.suite.getFullName())) {
         this.log("");
         this.log('>>> Running suite "' + spec.suite.getFullName() + '"', "yellow");
         this.suite_names.push(spec.suite.getFullName());
      }
      this.executed_specs++;
   };

   proto.reportSpecResults = function (spec) {
      if(spec.results().skipped) return;
      var totalCount = spec.results().totalCount;
      if (spec.results().passed()) {
         this.passed_specs++;

         var passedCount = spec.results().passedCount;
         this.log('    "' + spec.description + '"', "green");
         return;
      }
      var failedCount = spec.results().failedCount;
      this.log('    "' + spec.description + '"', "red");

      var items = spec.results().getItems();
      for (var i = 0; i < items.length; i++) {
         var text = items[i].message;
         if (text != null && text != "") {
            this.log("        " + text.replace(/\n/g, '\n        '), "red");
         }
      }
      this.log("");
   };

   proto.reportSuiteResults = function (suite) {
   };

   proto.log = function (str, color) {
      var text = (color != undefined) ? ANSI.colorize_text(str, color) : str;
      console.log(text)
   };

   jasmine.ConsoleReporter = ConsoleReporter;
})(jasmine, console);

