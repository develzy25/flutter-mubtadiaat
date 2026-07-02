import sharp from 'sharp';

async function processLogo() {
  const orig = 'src/assets/logo.png';
  
  // Just resize to standard sizes without complex 3D in sharp if it fails, 
  // but let's try a simple drop shadow by just compositing it over a black blurred version!
  
  const shadow = await sharp(orig)
    .resize(512, 512, { fit: 'contain', background: {r:0,g:0,b:0,alpha:0} })
    .modulate({ brightness: 0 }) // make it black
    .blur(10)
    .png()
    .toBuffer();

  const original = await sharp(orig)
    .resize(512, 512, { fit: 'contain', background: {r:0,g:0,b:0,alpha:0} })
    .png()
    .toBuffer();

  const result = await sharp({
    create: { width: 600, height: 600, channels: 4, background: { r: 0, g: 0, b: 0, alpha: 0 } }
  })
  .composite([
    { input: shadow, left: 54, top: 54 }, // shadow offset +10
    { input: original, left: 44, top: 44 }
  ])
  .png()
  .toBuffer();

  await sharp(result).toFile('public/logo-3d.png');
  await sharp(result).resize(192, 192).toFile('public/logo192.png');
  await sharp(result).resize(512, 512).toFile('public/logo512.png');
  await sharp(result).resize(64, 64).toFile('public/favicon.png');
  
  console.log('Done!');
}
processLogo().catch(console.error);
