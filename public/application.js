$(document).ready(function() {
    $("#sortable").sortable();    
});


$(document).ready(function() {
    $('#sortable2').sortable({
    axis: 'y',
    update: function (event, ui) {
        var data = $(this).sortable('serialize');

        // POST to server using $.post or $.ajax
        $.ajax({
            data: data,
            type: 'POST',
            url: '/step_1/sorted'
        });
    }
});   
});


$(document).ready(function() {
    $('#sortable_options_1, #sortable_options_2, #sortable_options_3, #sortable_options_4, #sortable_options_5').sortable({
    axis: 'y',
    update: function (event, ui) {
        var data = $(this).sortable('serialize');

        // POST to server using $.post or $.ajax
        $.ajax({
            data: data,
            type: 'POST',
            url: '/step_2/sorted_options'
        });
    }
});   
});
