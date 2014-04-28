$(function(){

    //$("#instance-list").tablesorter();
    //$("#booklist").tablesorter();
    //$("#instance-list").tablesorter({
    $('table').tablesorter({
      //sortList: [[1,0]],

      // initialize zebra striping and filter widgets 
      widgets: ["filter"], 
 
      //headers: { 5: { sorter: false, filter: false } }, 
      //headers: {0: { filter: false }, 3: { filter: false }, 4: { filter: false }},
 
      widgetOptions : { 
        // css class applied to the table row containing the filters & the inputs within that row 
        filter_cssFilter : 'tablesorter-filter', 
 
        // filter widget: If there are child rows in the table (rows with class name from "cssChildRow" option) 
        // and this option is true and a match is found anywhere in the child row, then it will make that row 
        // visible; default is false 
        filter_childRows : false, 
 
        // Set this option to true to use the filter to find text from the start of the column 
        // So typing in "a" will find "albert" but not "frank", both have a's; default is false 
        filter_startsWith : false,

        // Add select box to 4th column (zero-based index)
        // each option has an associated function that returns a boolean
        // function variables:
        // e = exact text from cell
        // n = normalized value returned by the column parser
        // f = search filter input value
        // i = column index
        filter_functions : {

          // Add select menu to this column
          // set the column value to true, and/or add "filter-select" class name to header
          // 0 : true,
          2 : true

          // Exact match only
          //1 : function(e, n, f, i, $r) {
          //  return e === f;
          //},

          //// Add these options to the select dropdown (regex example)
          //2 : {
          //  "A - D" : function(e, n, f, i, $r) { return /^[A-D]/.test(e); },
          //  "E - H" : function(e, n, f, i, $r) { return /^[E-H]/.test(e); },
          //  "I - L" : function(e, n, f, i, $r) { return /^[I-L]/.test(e); },
          //  "M - P" : function(e, n, f, i, $r) { return /^[M-P]/.test(e); },
          //  "Q - T" : function(e, n, f, i, $r) { return /^[Q-T]/.test(e); },
          //  "U - X" : function(e, n, f, i, $r) { return /^[U-X]/.test(e); },
          //  "Y - Z" : function(e, n, f, i, $r) { return /^[Y-Z]/.test(e); }
          //},

          //// Add these options to the select dropdown (numerical comparison example)
          //// Note that only the normalized (n) value will contain numerical data
          //// If you use the exact text, you'll need to parse it (parseFloat or parseInt)
          //4 : {
          //  "< $10"      : function(e, n, f, i, $r) { return n < 10; },
          //  "$10 - $100" : function(e, n, f, i, $r) { return n >= 10 && n <=100; },
          //  "> $100"     : function(e, n, f, i, $r) { return n > 100; }
          //}
        }
 


      } 
    });

});
