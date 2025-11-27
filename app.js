
(function(){
  const data = window.__SITE_DATA__;
  const container = document.getElementById('sections');
  const searchEl = document.getElementById('search');

  function render(filter=''){
    container.innerHTML = '';
    const q = filter.trim().toLowerCase();
    for(const section of data.sections){
      // Filter items per section
      const items = section.items
        .map(text => ({ text, html: highlight(text, q), visible: text.toLowerCase().includes(q) || !q }))
        .filter(x => x.visible);

      if(!items.length) continue;

      const card = document.createElement('section');
      card.className = 'card';
      card.id = section.id;
      card.innerHTML = `
        <header>
          <h3>${section.label}</h3>
          <span class="pill">${items.length}</span>
        </header>
        <ul class="list"></ul>
      `;
      const ul = card.querySelector('.list');
      for(const it of items){
        const li = document.createElement('li');
        li.className = 'item';
        li.innerHTML = it.html;
        ul.appendChild(li);
      }
      container.appendChild(card);
    }
  }

  function escapeHtml(s){return s.replace(/[&<>"]/g, c => ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;'}[c]));}
  function highlight(text, q){
    if(!q) return escapeHtml(text);
    const idx = text.toLowerCase().indexOf(q);
    if(idx === -1) return escapeHtml(text);
    const before = escapeHtml(text.slice(0, idx));
    const match = escapeHtml(text.slice(idx, idx + q.length));
    const after  = escapeHtml(text.slice(idx + q.length));
    return `${before}<mark>${match}</mark>${after}`;
  }

  searchEl.addEventListener('input', e => render(e.target.value));
  render();
})();
