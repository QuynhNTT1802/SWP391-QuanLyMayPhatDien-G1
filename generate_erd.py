"""
Generate draw.io XML (mxGraphModel) cho Crow's Foot ER Diagram
Database: warehousedb - 43 bang
Style: don gian, khong mau me
"""

# === CAU HINH LAYOUT ===
TABLE_W = 180
TABLE_H = 50
COL_SPACE = 220
ROW_SPACE = 100
ORIGIN_X = 40
ORIGIN_Y = 40

# Style don gian - hinh vuong, nen trang, vien den
VERTEX_STYLE = "rounded=0;whiteSpace=wrap;html=1;"
# Edge style mac dinh - duong thang
EDGE_BASE = "endArrow=ERmany;startArrow=ERone;exitX=0;exitY=0.5;exitDx=0;exitDy=0;entryX=0;entryY=0.5;entryDx=0;entryDy=0;"

# === VI TRI CAC BANG (col, row) ===
# col: 1-8, row: 1-6
POSITIONS = {
    # Row 1: Auth/User + Partners
    "user": (1, 1), "role": (2, 1), "permission": (3, 1),
    "user_role": (4, 1), "role_permission": (5, 1), "user_permission": (6, 1),
    "customer": (7, 1), "supplier": (8, 1),
    # Row 2: Category group
    "category": (1, 2), "category_brand": (2, 2), "category_condition": (3, 2),
    "category_customer_type": (4, 2), "category_fuel_type": (5, 2),
    "category_generator_type": (6, 2), "category_origin": (7, 2), "category_phase": (8, 2),
    # Row 3: Category_reason + Generator/Warehouse/Sales
    "category_receipt_reason": (1, 3), "generator": (2, 3), "generator_category": (3, 3),
    "warehouse": (4, 3), "inventory": (5, 3), "serial_number": (6, 3),
    "sale_order": (7, 3), "order_detail": (8, 3),
    # Row 4: Sales/Receipt + Purchase + Inventory_check
    "order_category": (1, 4), "receipt": (2, 4), "receipt_detail": (3, 4),
    "import_proposal": (4, 4), "import_proposal_detail": (5, 4),
    "purchase_order": (6, 4), "purchase_order_detail": (7, 4), "inventory_check": (8, 4),
    # Row 5: Operations + Liquidation + System
    "inventory_check_detail": (1, 5), "inventory_check_serial": (2, 5),
    "transfer": (3, 5), "transfer_detail": (4, 5), "stock_card": (5, 5),
    "liquidation": (6, 5), "liquidation_detail": (7, 5), "activity_log": (8, 5),
    # Row 6: System
    "notification": (1, 6), "system_log": (2, 6), "password_reset_request": (3, 6),
}

# === QUAN HE (source, target, style) ===
# Cac loai style cho Crow's Foot:
#  - "1N" : 1 bat buoc -> N bat buoc (ERone -> ERmany)
#  - "1Nopt" : 1 bat buoc -> 0..N (ERone -> ERzeroOrMany)
#  - "1opt_N" : 0..1 -> N (ERzeroOrOne -> ERmany) - it xuat hien
#  - "11" : 1 - 1 (ERone -> ERone)
#  - "NN" : N - N (ERmany -> ERmany) - qua bang trung gian
#  - "1_0_1" : 1 -> 0..1 (ERone -> ERzeroOrOne)

RELATIONSHIPS = [
    # === Self-reference user (created_by, updated_by) ===
    ("user", "user", "1Nopt"),

    # === Tu user (1 - 0..N) ===
    ("user", "activity_log", "1Nopt"),
    ("user", "notification", "1Nopt"),
    ("user", "system_log", "1Nopt"),
    ("user", "password_reset_request", "1Nopt"),
    ("user", "customer", "1Nopt"),
    ("user", "supplier", "1Nopt"),
    ("user", "generator", "1Nopt"),
    ("user", "sale_order", "1Nopt"),
    ("user", "import_proposal", "1Nopt"),
    ("user", "purchase_order", "1Nopt"),
    ("user", "receipt", "1Nopt"),
    ("user", "liquidation", "1Nopt"),
    ("user", "inventory_check", "1Nopt"),
    ("user", "stock_card", "1Nopt"),
    ("user", "transfer", "1Nopt"),

    # === N-N qua bang trung gian ===
    ("user", "role", "NN"),
    ("user", "permission", "NN"),
    ("role", "permission", "NN"),
    ("generator", "category", "NN"),
    ("sale_order", "category", "NN"),

    # === Tu category (1-1 voi cac sub-table) ===
    ("category", "category_brand", "11"),
    ("category", "category_condition", "11"),
    ("category", "category_customer_type", "11"),
    ("category", "category_fuel_type", "11"),
    ("category", "category_generator_type", "11"),
    ("category", "category_origin", "11"),
    ("category", "category_phase", "11"),
    ("category", "category_receipt_reason", "11"),

    # === Tu category (1 - 0..N hoac 1 - N) ===
    ("category", "customer", "1Nopt"),
    ("category", "supplier", "1Nopt"),
    ("category", "generator_category", "1N"),
    ("category", "order_category", "1N"),
    ("category", "liquidation", "1N"),
    ("category", "receipt", "1Nopt"),

    # === Tu generator (1 - N) ===
    ("generator", "inventory", "1N"),
    ("generator", "serial_number", "1N"),
    ("generator", "order_detail", "1N"),
    ("generator", "import_proposal_detail", "1N"),
    ("generator", "purchase_order_detail", "1N"),
    ("generator", "liquidation_detail", "1N"),
    ("generator", "inventory_check_detail", "1N"),
    ("generator", "transfer_detail", "1N"),
    ("generator", "stock_card", "1N"),

    # === Tu warehouse (1 - N) ===
    ("warehouse", "inventory", "1N"),
    ("warehouse", "serial_number", "1N"),
    ("warehouse", "inventory_check", "1N"),
    ("warehouse", "import_proposal", "1N"),
    ("warehouse", "purchase_order", "1N"),
    ("warehouse", "receipt", "1N"),
    ("warehouse", "liquidation", "1N"),
    ("warehouse", "transfer", "1N"),  # source_warehouse_id
    ("warehouse", "stock_card", "1N"),
    # dest_warehouse_id cung la warehouse -> transfer (them 1 line)
    ("warehouse", "transfer", "1N"),

    # === Tu customer/supplier ===
    ("customer", "sale_order", "1Nopt"),
    ("customer", "liquidation", "1Nopt"),
    ("supplier", "import_proposal_detail", "1Nopt"),

    # === Tu inventory ===
    ("inventory", "receipt_detail", "1N"),

    # === Tu sale_order ===
    ("sale_order", "order_detail", "1N"),
    ("sale_order", "receipt", "1Nopt"),

    # === Tu import_proposal ===
    ("import_proposal", "import_proposal_detail", "1N"),
    ("import_proposal", "purchase_order", "1_0_1"),

    # === Tu purchase_order ===
    ("purchase_order", "purchase_order_detail", "1N"),

    # === Tu receipt ===
    ("receipt", "receipt_detail", "1N"),
    ("receipt", "stock_card", "1Nopt"),
    ("receipt", "liquidation", "1_0_1"),

    # === Tu liquidation ===
    ("liquidation", "liquidation_detail", "1N"),

    # === Tu transfer ===
    ("transfer", "transfer_detail", "1N"),

    # === Tu inventory_check ===
    ("inventory_check", "inventory_check_detail", "1N"),
    ("inventory_check_detail", "inventory_check_serial", "1N"),
]

# === STYLE CHO TUNG LOAI QUAN HE ===
def get_edge_style(rel_type):
    if rel_type == "1N":
        return "endArrow=ERmany;startArrow=ERone;exitX=0;exitY=0.5;exitDx=0;exitDy=0;entryX=0;entryY=0.5;entryDx=0;entryDy=0;"
    elif rel_type == "1Nopt":
        return "endArrow=ERzeroOrMany;startArrow=ERone;exitX=0;exitY=0.5;exitDx=0;exitDy=0;entryX=0;entryY=0.5;entryDx=0;entryDy=0;"
    elif rel_type == "11":
        return "endArrow=ERone;startArrow=ERone;exitX=0;exitY=0.5;exitDx=0;exitDy=0;entryX=0;entryY=0.5;entryDx=0;entryDy=0;"
    elif rel_type == "NN":
        return "endArrow=ERmany;startArrow=ERmany;exitX=0;exitY=0.5;exitDx=0;exitDy=0;entryX=0;entryY=0.5;entryDx=0;entryDy=0;"
    elif rel_type == "1_0_1":
        return "endArrow=ERzeroOrOne;startArrow=ERone;exitX=0;exitY=0.5;exitDx=0;exitDy=0;entryX=0;entryY=0.5;entryDx=0;entryDy=0;"
    return ""

# === GENERATE XML ===
def generate_xml():
    lines = []
    lines.append('<mxfile host="app.diagrams.net">')
    lines.append('  <diagram id="crowfoot-erd" name="ER Diagram">')
    # page width = 8 cols * 220 + 40 = 1800, height = 6 rows * 100 + 40 = 640
    lines.append('    <mxGraphModel dx="2000" dy="1500" grid="1" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="1" pageScale="1" pageWidth="1820" pageHeight="660" math="0" shadow="0">')
    lines.append('      <root>')
    lines.append('        <mxCell id="0" />')
    lines.append('        <mxCell id="1" parent="0" />')

    # Vertices
    vertex_ids = {}
    counter = 2
    for table, (col, row) in POSITIONS.items():
        x = ORIGIN_X + (col - 1) * COL_SPACE
        y = ORIGIN_Y + (row - 1) * ROW_SPACE
        vid = f"v{counter}"
        vertex_ids[table] = vid
        counter += 1
        lines.append(f'        <mxCell id="{vid}" value="{table}" style="{VERTEX_STYLE}" vertex="1" parent="1">')
        lines.append(f'          <mxGeometry x="{x}" y="{y}" width="{TABLE_W}" height="{TABLE_H}" as="geometry" />')
        lines.append(f'        </mxCell>')

    # Edges
    edge_counter = 1
    for src, tgt, rel in RELATIONSHIPS:
        if src not in vertex_ids or tgt not in vertex_ids:
            continue
        eid = f"e{edge_counter}"
        edge_counter += 1
        style = get_edge_style(rel)
        # Self-loop can xu ly rieng
        if src == tgt:
            style = "endArrow=ERzeroOrMany;startArrow=ERone;exitX=1;exitY=0.5;exitDx=0;exitDy=0;entryX=1;entryY=0.5;entryDx=0;entryDy=0;"
        lines.append(f'        <mxCell id="{eid}" style="{style}" edge="1" parent="1" source="{vertex_ids[src]}" target="{vertex_ids[tgt]}">')
        lines.append(f'          <mxGeometry relative="1" as="geometry" />')
        lines.append(f'        </mxCell>')

    lines.append('      </root>')
    lines.append('    </mxGraphModel>')
    lines.append('  </diagram>')
    lines.append('</mxfile>')
    return '\n'.join(lines)

if __name__ == "__main__":
    xml = generate_xml()
    with open("D:/tailieu/ki 5/swp391/project/SWP391-QuanLyMayPhatDien-G1/crowfoot_erd.drawio", "w", encoding="utf-8") as f:
        f.write(xml)
    print(f"Da generate xong. So bang: {len(POSITIONS)}, So quan he: {len(RELATIONSHIPS)}")
    print(f"File: crowfoot_erd.drawio")
