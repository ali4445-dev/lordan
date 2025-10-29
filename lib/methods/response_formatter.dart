String formatApiText(String text) {
  // 1️⃣ Convert ##...## to titles (uppercase with line breaks)
  text = text.replaceAllMapped(RegExp(r'##(.*?)##'), (match) {
    final title = match.group(1)?.trim() ?? '';
    return '\n${title.toUpperCase()}\n';
  });

  // 2️⃣ Convert **...** to bold (using bold Unicode letters)
  text = text.replaceAllMapped(RegExp(r'\*\*(.*?)\*\*'), (match) {
    final boldText = match.group(1)?.trim() ?? '';
    return _toBold(boldText);
  });

  return text.trim();
}

// Helper: convert normal text to bold Unicode
String _toBold(String input) {
  const normal =
      'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  const bold = '𝗮𝗯𝗰𝗱𝗲𝗳𝗴𝗵𝗶𝗷𝗸𝗹𝗺𝗻𝗼𝗽𝗾𝗿𝘀𝘁𝘂𝗏𝗐𝗑𝗒𝗓'
      '𝗔𝗕𝗖𝗗𝗘𝗙𝗚𝗛𝗜𝗝𝗞𝗟𝗠𝗡𝗢𝗣𝗤𝗥𝗦𝗧𝗨𝗩𝗪𝗫𝗬𝗭'
      '𝟬𝟭𝟮𝟯𝟰𝟱𝟲𝟳𝟴𝟵';

  return input.split('').map((c) {
    final index = normal.indexOf(c);
    return index != -1 ? bold[index] : c;
  }).join('');
}
