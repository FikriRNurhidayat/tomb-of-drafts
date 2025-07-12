async function main() {
  // Configuration
  const iconSize = 48;
  const space = 96;
  const marginRight = 128;

  const backdrop = await loadImage("/assets/backdrop.jpeg");
  const music = new Audio("/assets/background.mp3");
  const click = new Audio("/assets/click.ogg");

  music.play();

  const response = await fetch("/menu.json");
  let menu = await response.json();
  let colIndex = 0;
  let rowIndex = 0;

  for (let cIdx = 0; cIdx < menu.length; cIdx++) {
    const entry = menu[cIdx];
    entry.active = cIdx === colIndex;
    entry.icon = await loadImage(`/assets/${entry.icon}`);
    // HACK: Tempoarily load every single image
    for (let rIdx = 0; rIdx < entry.items.length; rIdx++) {
      const item = entry.items[rIdx];
      item.active = rIdx === rowIndex;
      item.icon = await loadImage(`/assets/${item.icon}`);
    }
  }

  const canvas = document.getElementById("xmb");
  const dpr = window.devicePixelRatio || 1;

  canvas.width = window.innerWidth * dpr;
  canvas.height = window.innerHeight * dpr;

  canvas.style.width = `${window.innerWidth}px`;
  canvas.style.height = `${window.innerHeight}px`;

  let height = canvas.height;
  let width = canvas.width;

  const ctx = canvas.getContext("2d");

  let mover = 0;

  window.addEventListener("resize", (event) => {
    canvas.width = window.innerWidth * dpr;
    canvas.height = window.innerHeight * dpr;
    canvas.style.width = `${window.innerWidth}px`;
    canvas.style.height = `${window.innerHeight}px`;
    height = canvas.height;
    width = canvas.width;
    window.requestAnimationFrame(draw);
  });

  window.addEventListener(
    "keydown",
    (event) => {
      const keyName = event.key;
      const col = menu[colIndex];

      switch (keyName) {
        case "ArrowRight":
          if (colIndex < menu.length - 1) {
            colIndex += 1;
            rowIndex = 0;
            playClick();
          }
          break;
        case "ArrowLeft":
          if (colIndex > 0) {
            colIndex -= 1;
            rowIndex = 0;
            playClick();
          }
          break;
        case "ArrowDown":
          if (rowIndex < col.items.length - 1) {
            rowIndex += 1;
            playClick();
          }
          break;
        case "ArrowUp":
          if (rowIndex > 0) {
            rowIndex -= 1;
            playClick();
          }
          break;
      }

      menu = menu.map((entry, index) => {
        entry.active = index === colIndex;
        entry.items = entry.items.map((item, index) => {
          item.active = entry.active && rowIndex === index;
          return item;
        });
        return entry;
      });

      window.requestAnimationFrame(draw);
    },
    false,
  );

  function draw() {
    ctx.clearRect(0, 0, width, height);
    ctx.font = "bold 10pt Noto Sans, sans-serif";
    ctx.scale(dpr, dpr); // Scale context
    ctx.globalAlpha = 1;
    ctx.drawImage(backdrop, 0, 0, width, height);

    const y = Math.floor(height / 2);

    const leftEntries = menu.slice(0, colIndex).reverse();
    const rightEntries = menu.slice(colIndex);

    for (let i = 0; i < leftEntries.length; i++) {
      const entry = leftEntries[i];
      const x = marginRight - (i + i + space + i * iconSize + i * space);
      if (x >= width) break;
      renderColumn(entry, x, y);
    }

    for (let i = 0; i < rightEntries.length; i++) {
      const entry = rightEntries[i];
      const x = marginRight + (i + 1 + space) + i * iconSize + i * space;
      if (x >= width) break;
      renderColumn(entry, x, y);
    }
  }

  function renderColumn(entry, x, y) {
    ctx.globalAlpha = entry.active ? 1 : 0.2;
    if (entry.active) {
      ctx.shadowBlur = 16;
      ctx.shadowColor = "rgba(255, 255, 255, 0.8)";
    } else {
      ctx.shadowBlur = undefined;
      ctx.shadowColor = undefined;
    }

    ctx.drawImage(entry.icon, x, y, iconSize, iconSize);

    if (entry.active) {
      const textMetrics = ctx.measureText(entry.name);
      const textHeight =
        textMetrics.actualBoundingBoxAscent +
        textMetrics.actualBoundingBoxDescent;
      ctx.textBaseline = "top";
      ctx.textAlign = "center";
      ctx.fillStyle = "white";
      ctx.fillText(
        entry.name,
        x + Math.floor(iconSize / 2),
        y + iconSize + space / 4,
      );

      const topItems = entry.items.slice(0, rowIndex).reverse();
      const bottomItems = entry.items.slice(rowIndex);

      for (let rIdx = 0; rIdx < topItems.length; rIdx++) {
        const item = topItems[rIdx];
        const yy = y - rIdx * iconSize - (rIdx + 1) * space;
        if (yy >= height) return;
        renderRow(item, x, yy);
      }

      for (let rIdx = 0; rIdx < bottomItems.length; rIdx++) {
        const item = bottomItems[rIdx];
        const xx = x + iconSize + space / 2;
        const yy = textHeight * 2 + (rIdx + 1) * space + y;
        renderRow(item, x, yy);
      }
    }
  }

  function renderRow(item, x, y) {
    const textMetrics = ctx.measureText(item.name);
    const textHeight =
      textMetrics.actualBoundingBoxAscent +
      textMetrics.actualBoundingBoxDescent;
    ctx.globalAlpha = item.active ? 1 : 0.2;
    if (item.active) {
      ctx.shadowBlur = 16;
      ctx.shadowColor = "rgba(255, 255, 255, 0.8)";
    } else {
      ctx.shadowBlur = undefined;
      ctx.shadowColor = undefined;
    }
    ctx.drawImage(item.icon, x, y, iconSize, iconSize);
    ctx.textBaseline = "center";
    ctx.textAlign = "left";
    ctx.fillStyle = "white";
    ctx.fillText(
      item.name,
      x + iconSize + Math.floor(space / 8),
      y + Math.floor(iconSize / 2) - textHeight / 2,
    );
  }

  function loadImage(src) {
    return new Promise((resolve) => {
      const image = new Image();
      image.addEventListener("load", () => resolve(image));
      image.src = src;
    });
  }

  window.requestAnimationFrame(draw);

  let clickCount = 0;
  let lastPlayed = 0;
  const maxClicks = 4;
  const throttleMs = 500; // 0.5 second throttle

  setInterval(() => {
    clickCount = 0;
  }, throttleMs);

  function playClick() {
    if (clickCount < maxClicks) {
      clickCount++;
      const clone = click.cloneNode(); // allow overlapping
      clone.play().catch(() => {});
      clone.onended = () => clone.remove();
    }
  }
}

main().catch((error) => {
  console.error(error);
});
