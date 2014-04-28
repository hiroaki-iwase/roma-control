$(function(){

    //$("#instance-list").tablesorter({
    $('table').tablesorter({
      sortList: [[1,0]],

      // initialize zebra striping and filter widgets 
      widgets: ["filter"], 
 
      //headers: { 5: { sorter: false, filter: false } }, 
      headers: {0: { filter: false }, 3: { filter: false }, 4: { filter: false }},
 
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
        }
      } 
    });

});
