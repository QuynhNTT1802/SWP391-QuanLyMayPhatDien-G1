$TABLE_W = 180
$TABLE_H = 50
$COL_SPACE = 220
$ROW_SPACE = 100
$ORIGIN_X = 40
$ORIGIN_Y = 40

$VERTEX_STYLE = "rounded=0;whiteSpace=wrap;html=1;"

$POSITIONS = [ordered]@{
    "user" = @(1, 1); "role" = @(2, 1); "permission" = @(3, 1);
    "user_role" = @(4, 1); "role_permission" = @(5, 1); "user_permission" = @(6, 1);
    "customer" = @(7, 1); "supplier" = @(8, 1);
    "category" = @(1, 2); "category_brand" = @(2, 2); "category_condition" = @(3, 2);
    "category_customer_type" = @(4, 2); "category_fuel_type" = @(5, 2);
    "category_generator_type" = @(6, 2); "category_origin" = @(7, 2); "category_phase" = @(8, 2);
    "category_receipt_reason" = @(1, 3); "generator" = @(2, 3); "generator_category" = @(3, 3);
    "warehouse" = @(4, 3); "inventory" = @(5, 3); "serial_number" = @(6, 3);
    "sale_order" = @(7, 3); "order_detail" = @(8, 3);
    "order_category" = @(1, 4); "receipt" = @(2, 4); "receipt_detail" = @(3, 4);
    "import_proposal" = @(4, 4); "import_proposal_detail" = @(5, 4);
    "purchase_order" = @(6, 4); "purchase_order_detail" = @(7, 4); "inventory_check" = @(8, 4);
    "inventory_check_detail" = @(1, 5); "inventory_check_serial" = @(2, 5);
    "transfer" = @(3, 5); "transfer_detail" = @(4, 5); "stock_card" = @(5, 5);
    "liquidation" = @(6, 5); "liquidation_detail" = @(7, 5); "activity_log" = @(8, 5);
    "notification" = @(1, 6); "system_log" = @(2, 6); "password_reset_request" = @(3, 6);
}

$RELATIONSHIPS = @(
    # Self-reference user
    @("user", "user", "1Nopt"),
    # Tu user
    @("user", "activity_log", "1Nopt"),
    @("user", "notification", "1Nopt"),
    @("user", "system_log", "1Nopt"),
    @("user", "password_reset_request", "1Nopt"),
    @("user", "customer", "1Nopt"),
    @("user", "supplier", "1Nopt"),
    @("user", "generator", "1Nopt"),
    @("user", "sale_order", "1Nopt"),
    @("user", "import_proposal", "1Nopt"),
    @("user", "purchase_order", "1Nopt"),
    @("user", "receipt", "1Nopt"),
    @("user", "liquidation", "1Nopt"),
    @("user", "inventory_check", "1Nopt"),
    @("user", "stock_card", "1Nopt"),
    @("user", "transfer", "1Nopt"),
    # N-N
    @("user", "role", "NN"),
    @("user", "permission", "NN"),
    @("role", "permission", "NN"),
    @("generator", "category", "NN"),
    @("sale_order", "category", "NN"),
    # Category 1-1
    @("category", "category_brand", "11"),
    @("category", "category_condition", "11"),
    @("category", "category_customer_type", "11"),
    @("category", "category_fuel_type", "11"),
    @("category", "category_generator_type", "11"),
    @("category", "category_origin", "11"),
    @("category", "category_phase", "11"),
    @("category", "category_receipt_reason", "11"),
    # Category 1-N
    @("category", "customer", "1Nopt"),
    @("category", "supplier", "1Nopt"),
    @("category", "generator_category", "1N"),
    @("category", "order_category", "1N"),
    @("category", "liquidation", "1N"),
    @("category", "receipt", "1Nopt"),
    # Generator 1-N
    @("generator", "inventory", "1N"),
    @("generator", "serial_number", "1N"),
    @("generator", "order_detail", "1N"),
    @("generator", "import_proposal_detail", "1N"),
    @("generator", "purchase_order_detail", "1N"),
    @("generator", "liquidation_detail", "1N"),
    @("generator", "inventory_check_detail", "1N"),
    @("generator", "transfer_detail", "1N"),
    @("generator", "stock_card", "1N"),
    # Warehouse 1-N
    @("warehouse", "inventory", "1N"),
    @("warehouse", "serial_number", "1N"),
    @("warehouse", "inventory_check", "1N"),
    @("warehouse", "import_proposal", "1N"),
    @("warehouse", "purchase_order", "1N"),
    @("warehouse", "receipt", "1N"),
    @("warehouse", "liquidation", "1N"),
    @("warehouse", "transfer", "1N"),
    @("warehouse", "stock_card", "1N"),
    @("warehouse", "transfer", "1N"),
    # Customer/Supplier
    @("customer", "sale_order", "1Nopt"),
    @("customer", "liquidation", "1Nopt"),
    @("supplier", "import_proposal_detail", "1Nopt"),
    # Inventory
    @("inventory", "receipt_detail", "1N"),
    # Sale_order
    @("sale_order", "order_detail", "1N"),
    @("sale_order", "receipt", "1Nopt"),
    # Import_proposal
    @("import_proposal", "import_proposal_detail", "1N"),
    @("import_proposal", "purchase_order", "1_0_1"),
    # Purchase_order
    @("purchase_order", "purchase_order_detail", "1N"),
    # Receipt
    @("receipt", "receipt_detail", "1N"),
    @("receipt", "stock_card", "1Nopt"),
    @("receipt", "liquidation", "1_0_1"),
    # Liquidation
    @("liquidation", "liquidation_detail", "1N"),
    # Transfer
    @("transfer", "transfer_detail", "1N"),
    # Inventory_check
    @("inventory_check", "inventory_check_detail", "1N"),
    @("inventory_check_detail", "inventory_check_serial", "1N")
)

function Get-EdgeStyle($rel, $src, $tgt) {
    if ($src -eq $tgt) {
        return "endArrow=ERzeroOrMany;startArrow=ERone;exitX=1;exitY=0.5;exitDx=0;exitDy=0;entryX=1;entryY=0.5;entryDx=0;entryDy=0;"
    }
    switch ($rel) {
        "1N" { return "endArrow=ERmany;startArrow=ERone;exitX=0;exitY=0.5;exitDx=0;exitDy=0;entryX=0;entryY=0.5;entryDx=0;entryDy=0;" }
        "1Nopt" { return "endArrow=ERzeroOrMany;startArrow=ERone;exitX=0;exitY=0.5;exitDx=0;exitDy=0;entryX=0;entryY=0.5;entryDx=0;entryDy=0;" }
        "11" { return "endArrow=ERone;startArrow=ERone;exitX=0;exitY=0.5;exitDx=0;exitDy=0;entryX=0;entryY=0.5;entryDx=0;entryDy=0;" }
        "NN" { return "endArrow=ERmany;startArrow=ERmany;exitX=0;exitY=0.5;exitDx=0;exitDy=0;entryX=0;entryY=0.5;entryDx=0;entryDy=0;" }
        "1_0_1" { return "endArrow=ERzeroOrOne;startArrow=ERone;exitX=0;exitY=0.5;exitDx=0;exitDy=0;entryX=0;entryY=0.5;entryDx=0;entryDy=0;" }
        default { return "" }
    }
}

$sb = New-Object System.Text.StringBuilder

[void]$sb.AppendLine('<mxfile host="app.diagrams.net">')
[void]$sb.AppendLine('  <diagram id="crowfoot-erd" name="ER Diagram">')
[void]$sb.AppendLine('    <mxGraphModel dx="2000" dy="1500" grid="1" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="1" pageScale="1" pageWidth="1820" pageHeight="660" math="0" shadow="0">')
[void]$sb.AppendLine('      <root>')
[void]$sb.AppendLine('        <mxCell id="0" />')
[void]$sb.AppendLine('        <mxCell id="1" parent="0" />')

$counter = 2
$vertexIds = @{}
foreach ($key in $POSITIONS.Keys) {
    $pos = $POSITIONS[$key]
    $col = $pos[0]
    $row = $pos[1]
    $x = $ORIGIN_X + ($col - 1) * $COL_SPACE
    $y = $ORIGIN_Y + ($row - 1) * $ROW_SPACE
    $vid = "v$counter"
    $vertexIds[$key] = $vid
    $counter++
    [void]$sb.AppendLine("        <mxCell id=`"$vid`" value=`"$key`" style=`"$VERTEX_STYLE`" vertex=`"1`" parent=`"1`">")
    [void]$sb.AppendLine("          <mxGeometry x=`"$x`" y=`"$y`" width=`"$TABLE_W`" height=`"$TABLE_H`" as=`"geometry`" />")
    [void]$sb.AppendLine("        </mxCell>")
}

$edgeCounter = 1
foreach ($rel in $RELATIONSHIPS) {
    $src = $rel[0]
    $tgt = $rel[1]
    $rtype = $rel[2]
    if (-not $vertexIds.ContainsKey($src) -or -not $vertexIds.ContainsKey($tgt)) { continue }
    $eid = "e$edgeCounter"
    $edgeCounter++
    $style = Get-EdgeStyle $rtype $src $tgt
    [void]$sb.AppendLine("        <mxCell id=`"$eid`" style=`"$style`" edge=`"1`" parent=`"1`" source=`"$($vertexIds[$src])`" target=`"$($vertexIds[$tgt])`">")
    [void]$sb.AppendLine("          <mxGeometry relative=`"1`" as=`"geometry`" />")
    [void]$sb.AppendLine("        </mxCell>")
}

[void]$sb.AppendLine('      </root>')
[void]$sb.AppendLine('    </mxGraphModel>')
[void]$sb.AppendLine('  </diagram>')
[void]$sb.AppendLine('</mxfile>')

$content = $sb.ToString()
$outPath = "D:\tailieu\ki 5\swp391\project\SWP391-QuanLyMayPhatDien-G1\crowfoot_erd.drawio"
[System.IO.File]::WriteAllText($outPath, $content, [System.Text.Encoding]::UTF8)
Write-Host "Da tao file: $outPath"
Write-Host "So bang: $($POSITIONS.Count)"
Write-Host "So quan he: $($RELATIONSHIPS.Count)"
Write-Host "Kich thuoc file: $($content.Length) bytes"
