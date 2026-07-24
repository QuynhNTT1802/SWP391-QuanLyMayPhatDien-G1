var RPT = RPT || {};

RPT.COLORS = {
    inventory: [
        {label:'Nhập', bg:'rgba(37,99,235,0.7)'},
        {label:'Xuất', bg:'rgba(220,38,38,0.7)'}
    ],
    import_:  [{label:'Số phiếu nhập', bg:'rgba(37,99,235,0.7)'}],
    export_:  [{label:'Số phiếu xuất', bg:'rgba(220,38,38,0.7)'}],
    check:    [{label:'Số phiếu kiểm', bg:'rgba(245,158,11,0.7)'}],
    purchase: [{label:'Chi tiêu',      bg:'rgba(139,92,246,0.7)'}],
    sales:    [{label:'Doanh thu',     bg:'rgba(5,150,105,0.7)'}]
};

RPT.initCharts = function() {
    if (!RPT.charts) return;
    RPT.charts.forEach(function(c) {
        var el = document.getElementById(c.id);
        if (!el) return;
        var d = c.data;
        if (!d || !d.length) return;
        var sets = RPT.COLORS[c.report];
        if (!sets) return;
        var isBar = c.report === 'inventory' || c.report === 'export_';
        var datasets = sets.map(function(s, i) {
            var colIdx = i + 1;
            return {
                label: s.label,
                data: d.map(function(x) { return x[colIdx]; }),
                backgroundColor: s.bg,
                borderColor: s.bg.replace('0.7','1'),
                borderWidth: isBar ? 0 : 2,
                tension: isBar ? undefined : 0.3,
                fill: isBar ? undefined : true
            };
        });
        new Chart(el, {
            type: isBar ? 'bar' : 'line',
            data: { labels: d.map(function(x) { return x[0]; }), datasets: datasets },
            options: {
                responsive: true,
                plugins: { legend: { display: sets.length > 1, position: 'bottom' } },
                scales: { y: { beginAtZero: true } }
            }
        });
    });
};

RPT.exportExcel = function() {
    var url = RPT.ctx + '/reports?action=export&type=' + RPT.type
        + '&month=' + RPT.month + '&year=' + RPT.year
        + '&warehouseId=' + RPT.warehouseId;
    window.location.href = url;
};
