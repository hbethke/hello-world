function addRow() {
    var newRow = '<tr><td><div class="input-group"><input name="" type="text" class="form-control"/></div></td>';
    newRow += '<td><div class="input-group"><input name="K" type="text" class="form-control" /></div></td>';
    newRow += '<td><button type="button" class="btn btn-xs btn-danger" onclick="deleteRow(this);"><span class="glyphicon glyphicon-trash"></span> Löschen</button></td></tr>';
    $("#dynamicTableBody").append($(newRow));
}

function deleteRow(selector) {
        $(selector).closest('tr').remove();
}