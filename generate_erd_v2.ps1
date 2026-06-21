$TABLE_W = 180
$TABLE_H = 50
$COL_SPACE = 200
$ROW_SPACE = 100
$ORIGIN_X = 40
$ORIGIN_Y = 40

$VERTEX_STYLE = "rounded=0;whiteSpace=wrap;html=1;"

$POSITIONS = [ordered]@{
    "user" = @(1, 1); "role" = @(2, 1); "permission" = @(3, 1);
    "user_role" = @(4, 1); "role_permission" = @(5, 1); "user_permission" = @(6, 1);
    "customer" = @(1, 2); "supplier" = @(2, 2); "activity_log" = @(3, 2);
    "notification" = @(4, 2); "system_log" = @(5, 2); "password_reset_request" = @(6, 2);
    "category" = @(1, 3); "category_brand" = @(2, 3); "category_condition" = @(3, 3);
    "category_customer_type" = @(4, 3); "category_fuel_type" = @(5, 3);
    "category_generator_type" = @(6, 3); "category_origin" = @(7, 3); "category_phase" = @(8, 3);
    "category_receipt_reason" = @(9, 3);
    "generator" = @(1, 4); "generator_category" = @(2, 4); "warehouse" = @(3, 4);
    "inventory" = @(4, 4); "serial_number" = @(5, 4); "stock_card" = @(6, 4);
    "sale_order" = @(7, 4); "order_detail" = @(8, 4); "order_category" = @(9, 4);
    "receipt" = @(1, 5); "receipt_detail" = @(2, 5);
    "import_proposal" = @(3, 5); "import_proposal_detail" = @(4, 5);
    "purchase_order" = @(5, 5); "purchase_order_detail" = @(6, 5);
    "liquidation" = @(7, 5); "liquidation_detail" = @(8, 5);
    "inventory_check" = @(1, 6); "inventory_check_detail" = @(2, 6);
    "inventory_check_serial" = @(3, 6); "transfer" = @(4, 6);
    "transfer_detail" = @(5, 6);
}

# (source, target, rel_type, verb)
$RELATIONSHIPS = @(
    # User - self ref
    @("user", "user", "1Nopt", "approving"),
    # User to system
    @("user", "activity_log", "1Nopt", "logging"),
    @("user", "notification", "1Nopt", "notifying"),
    @("user", "system_log", "1Nopt", "logging"),
    @("user", "password_reset_request", "1Nopt", "resetting"),
    # User to partners
    @("user", "customer", "1Nopt", "managing"),
    @("user", "supplier", "1Nopt", "managing"),
    @("user", "generator", "1Nopt", "managing"),
    # User to sales/purchase
    @("user", "sale_order", "1Nopt", "ordering"),
    @("user", "import_proposal", "1Nopt", "proposing"),
    @("user", "purchase_order", "1Nopt", "purchasing"),
    @("user", "receipt", "1Nopt", "receiving"),
    @("user", "liquidation", "1Nopt", "liquidating"),
    # User to operations
    @("user", "inventory_check", "1Nopt", "checking"),
    @("user", "stock_card", "1Nopt", "recording"),
    @("user", "transfer", "1Nopt", "transferring"),
    # N-N
    @("user", "role", "NN", "assigning"),
    @("user", "permission", "NN", "granting"),
    @("role", "permission", "NN", "permitting"),
    @("generator", "category", "NN", "classifying"),
    @("sale_order", "category", "NN", "categorizing"),
    # Category 1-1
    @("category", "category_brand", "11", "branding"),
    @("category", "category_condition", "11", "conditioning"),
    @("category", "category_customer_type", "11", "typing"),
    @("category", "category_fuel_type", "11", "fueling"),
    @("category", "category_generator_type", "11", "grouping"),
    @("category", "category_origin", "11", "originating"),
    @("category", "category_phase", "11", "phasing"),
    @("category", "category_receipt_reason", "11", "reasoning"),
    # Category 1-N
    @("category", "customer", "1Nopt", "classifying"),
    @("category", "supplier", "1Nopt", "classifying"),
    @("category", "generator_category", "1N", "categorizing"),
    @("category", "order_category", "1N", "categorizing"),
    @("category", "liquidation", "1N", "reasoning"),
    @("category", "receipt", "1Nopt", "reasoning"),
    # Generator 1-N
    @("generator", "inventory", "1N", "stocking"),
    @("generator", "serial_number", "1N", "serializing"),
    @("generator", "order_detail", "1N", "including"),
    @("generator", "import_proposal_detail", "1N", "proposing"),
    @("generator", "purchase_order_detail", "1N", "detailing"),
    @("generator", "liquidation_detail", "1N", "liquidating"),
    @("generator", "inventory_check_detail", "1N", "checking"),
    @("generator", "transfer_detail", "1N", "transferring"),
    @("generator", "stock_card", "1N", "recording"),
    # Warehouse 1-N
    @("warehouse", "inventory", "1N", "storing"),
    @("warehouse", "serial_number", "1N", "housing"),
    @("warehouse", "inventory_check", "1N", "auditing"),
    @("warehouse", "import_proposal", "1N", "supplying"),
    @("warehouse", "purchase_order", "1N", "ordering"),
    @("warehouse", "receipt", "1N", "receiving"),
    @("warehouse", "liquidation", "1N", "releasing"),
    @("warehouse", "transfer", "1N", "dispatching"),
    @("warehouse", "stock_card", "1N", "tracking"),
    @("warehouse", "transfer", "1N", "receiving"),
    # Customer/Supplier
    @("customer", "sale_order", "1Nopt", "purchasing"),
    @("customer", "liquidation", "1Nopt", "selling"),
    @("supplier", "import_proposal_detail", "1Nopt", "supplying"),
    # Inventory
    @("inventory", "receipt_detail", "1N", "fulfilling"),
    # Sale_order
    @("sale_order", "order_detail", "1N", "including"),
    @("sale_order", "receipt", "1Nopt", "fulfilling"),
    # Import_proposal
    @("import_proposal", "import_proposal_detail", "1N", "detailing"),
    @("import_proposal", "purchase_order", "1_0_1", "referencing"),
    # Purchase_order
    @("purchase_order", "purchase_order_detail", "1N", "detailing"),
    # Receipt
    @("receipt", "receipt_detail", "1N", "detailing"),
    @("receipt", "stock_card", "1Nopt", "updating"),
    @("receipt", "liquidation", "1_0_1", "converting"),
    # Liquidation
    @("liquidation", "liquidation_detail", "1N", "listing"),
    # Transfer
    @("transfer", "transfer_detail", "1N", "listing"),
    # Inventory_check
    @("inventory_check", "inventory_check_detail", "1N", "including"),
    @("inventory_check_detail", "inventory_check_serial", "1N", "scanning")
)

function Get-EdgeStyle($rel, $src, $tgt) {
    $base = "labelBackgroundColor=#FFFFFF;fontSize=10;"
    if ($src -eq $tgt) {
        return $base + "endArrow=ERzeroOrMany;startArrow=ERone;exitX=1;exitY=0.5;exitDx=0;exitDy=0;entryX=1;entryY=0.5;entryDx=0;entryDy=0;"
    }
    switch ($rel) {
        "1N" { return $base + "endArrow=ERmany;startArrow=ERone;exitX=0;exitY=0.5;exitDx=0;exitDy=0;entryX=0;entryY=0.5;entryDx=0;entryDy=0;" }
        "1Nopt" { return $base + "endArrow=ERzeroOrMany;startArrow=ERone;exitX=0;exitY=0.5;exitDx=0;exitDy=0;entryX=0;entryY=0.5;entryDx=0;entryDy=0;" }
        "11" { return $base + "endArrow=ERone;startArrow=ERone;exitX=0;exitY=0.5;exitDx=0;exitDy=0;entryX=0;entryY=0.5;entryDx=0;entryDy=0;" }
        "NN" { return $base + "endArrow=ERmany;startArrow=ERmany;exitX=0;exitY=0.5;exitDx=0;exitDy=0;entryX=0;entryY=0.5;entryDx=0;entryDy=0;" }
        "1_0_1" { return $base + "endArrow=ERzeroOrOne;startArrow=ERone;exitX=0;exitY=0.5;exitDx=0;exitDy=0;entryX=0;entryY=0.5;entryDx=0;entryDy=0;" }
        default { return $base }
    }
}

$sb = New-Object System.Text.StringBuilder

[void]$sb.AppendLine('<mxfile host="app.diagrams.net">')
[void]$sb.AppendLine('  <diagram id="crowfoot-erd-v2" name="ER Diagram">')
[void]$sb.AppendLine('    <mxGraphModel dx="2000" dy="1500" grid="1" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="1" pageScale="1" pageWidth="1880" pageHeight="660" math="0" shadow="0">')
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
    $verb = $rel[3]
    if (-not $vertexIds.ContainsKey($src) -or -not $vertexIds.ContainsKey($tgt)) { continue }
    $eid = "e$edgeCounter"
    $edgeCounter++
    $style = Get-EdgeStyle $rtype $src $tgt
    [void]$sb.AppendLine("        <mxCell id=`"$eid`" value=`"$verb`" style=`"$style`" edge=`"1`" parent=`"1`" source=`"$($vertexIds[$src])`" target=`"$($vertexIds[$tgt])`">")
    [void]$sb.AppendLine("          <mxGeometry relative=`"1`" as=`"geometry`" />")
    [void]$sb.AppendLine("        </mxCell>")
}

[void]$sb.AppendLine('      </root>')
[void]$sb.AppendLine('    </mxGraphModel>')
[void]$sb.AppendLine('  </diagram>')
[void]$sb.AppendLine('</mxfile>')

$content = $sb.ToString()
$outPath = "D:\tailieu\ki 5\swp391\project\SWP391-QuanLyMayPhatDien-G1\crowfoot_erd_v2.drawio"
[System.IO.File]::WriteAllText($outPath, $content, [System.Text.Encoding]::UTF8)
Write-Host "OK! File: $outPath"
Write-Host "Bang: $($POSITIONS.Count) | Quan he: $($RELATIONSHIPS.Count) | Kich thuoc: $($content.Length) bytes"
