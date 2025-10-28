String formatApiText(String text) {
  // Convert ##...## to a title (uppercase with line breaks)
  text = text.replaceAllMapped(RegExp(r'##(.*?)##'), (match) {
    final title = match.group(1)?.trim() ?? '';
    return '\n${title.toUpperCase()}\n';
  });

  // Convert **...** to bold (using real bold Unicode letters)
  text = text.replaceAllMapped(RegExp(r'\*\*(.*?)\*\*'), (match) {
    final boldText = match.group(1)?.trim() ?? '';
    return _toBold(boldText);
  });

  return text.trim();
}

// Helper to convert normal text to bold Unicode characters
String _toBold(String input) {
  const normal =
      'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  const bold = '𝗮𝗯𝗰𝗱𝗲𝗳𝗴𝗵𝗶𝗷𝗸𝗹𝗺𝗻𝗼𝗽𝗾𝗿𝘀𝘁𝘂𝘃𝘄𝘅𝘆𝘇'
      '𝗔𝗕𝗖𝗗𝗘𝗙𝗚𝗛𝗜𝗝𝗞𝗟𝗠𝗡𝗢𝗣𝗤𝗥𝗦𝗧𝗨𝗩𝗪𝗫𝗬𝗭'
      '𝟬𝟭𝟮𝟯𝟰𝟱𝟲𝟳𝟴𝟵';

  return input.split('').map((c) {
    final index = normal.indexOf(c);
    return index != -1 ? bold[index] : c;
  }).join('');
}
