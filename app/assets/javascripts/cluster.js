$(function(){
    $('table.tablesorter').tablesorter({
      theme: 'default',
      sortList: [[0,0]],
      widthFixed: true,
      widgets: ["filter"], 
      headers: {0: { filter: false }, 3: { filter: false }, 4: { filter: false }, 5: { filter: false, sorter: false }},
      widgetOptions : { 
        filter_reset : 'button.reset-filter',
        filter_cssFilter : 'tablesorter-filter', 
        filter_functions : {
          2 : true
        }
      } 
    });

    var x = 0;
    function myFunc() {
        // get total vnodes
        var totalVnodes = ;

        // get short vnodes
        var shortVnodes = ;
        //x++; 

        // caliculate
        var barval = ((totalVnodes - shortVnodes)/TotalVnodes)*100;
        //var barVal = (1-1/(x+1))*100;

        //console.log(barVal);
        $('#extra-progress-bar').css("width",barVal + "%");
        $('#extra-bar-rate').text(barVal+ "% Complete");
        setTimeout(myFunc,300);
    }
    
    $(function(){
        setTimeout(myFunc,300);
    });

});
