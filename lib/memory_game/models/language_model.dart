class LanguageModel {
  final Map<String, String> translations;

  LanguageModel(this.translations);

  String get(String key) {
    return translations[key] ?? key;
  }
}

// Tüm dil çevirileri
class LanguageData {
  static LanguageModel english = LanguageModel({
    // Home page
    'app_title': 'MEMORY MATCH',
    'app_tagline': 'Test your memory skills with fun!',
    'play_now': 'PLAY NOW',
    'how_to_play': 'HOW TO PLAY',
    'high_scores': 'HIGH SCORES',
    'settings': 'SETTINGS',
    
    // Settings page
    'settings_title': 'Settings',
    'language': 'Language',
    'theme': 'Theme',
    'dark_mode': 'Dark Mode',
    'light_mode': 'Light Mode',
    'save': 'Save',
    
    // Navigation
    'back': 'Back',
    
    // Difficulty selection
    'select_difficulty': 'Select Difficulty',
    'choose_challenge': 'Choose your challenge level',
    'easy': 'Easy',
    'easy_desc': 'For beginners',
    'easy_pairs': '6 pairs of cards',
    'medium': 'Medium',
    'medium_desc': 'Regular challenge',
    'medium_pairs': '10 pairs of cards',
    'hard': 'Hard',
    'hard_desc': 'For memory masters',
    'hard_pairs': '15 pairs of cards',
    'expert': 'Expert',
    'expert_desc': 'Ultimate challenge',
    'expert_pairs': '20 pairs of cards',
    'locked': 'LOCKED',
    'feature_locked': 'Feature Locked',
    'locked_description': 'This difficulty level will be available in future updates! Complete challenges in other difficulty levels first.',
    'ok_got_it': 'OK, GOT IT',
    
    // Game screen
    'loading_cards': 'Loading Cards...',
    'congratulations': 'Congratulations!',
    'game_completed': 'You completed the game! 🎉',
    'time': 'Time:',
    'score': 'Score:',
    'points': 'points',
    'moves': 'Moves:',
    'moves_value': 'moves',
    'difficulty': 'Difficulty:',
    'play_again': 'Play Again',
    'main_menu': 'Main Menu',
    'exit_game': 'Exit Game',
    'exit_confirm': 'Are you sure you want to exit? Your progress will not be saved.',
    'cancel': 'Cancel',
    'exit': 'Exit',
    
    // Tutorial
    'tutorial_title': 'How To Play',
    'tutorial_step1_title': 'Game Objective',
    'tutorial_step1_desc': 'Match all pairs of cards to complete the game. The faster you match with fewer moves, the higher your score!',
    'tutorial_step2_title': 'How To Play',
    'tutorial_step2_desc': 'Tap on any card to reveal it. Then try to find its matching pair. If the cards match, they remain face up. If not, they flip back.',
    'tutorial_step3_title': 'Scoring',
    'tutorial_step3_desc': 'Score is based on your speed and number of moves. Fewer moves and faster completion earn higher scores!',
    'tutorial_step4_title': 'Difficulty Levels',
    'tutorial_step4_desc': 'Choose from Easy (6 pairs), Medium (10 pairs), or Hard (15 pairs) modes. Expert mode unlocks as you improve!',
    'next': 'Next',
    'got_it': 'Got It',
  });

  static LanguageModel turkish = LanguageModel({
    // Ana sayfa
    'app_title': 'MEMORY MATCH',
    'app_tagline': 'Hafıza becerilerinizi eğlenceli bir şekilde test edin!',
    'play_now': 'HEMEN OYNA',
    'how_to_play': 'NASIL OYNANIR',
    'high_scores': 'YÜKSEK SKORLAR',
    'settings': 'AYARLAR',
    
    // Ayarlar sayfası
    'settings_title': 'Ayarlar',
    'language': 'Dil',
    'theme': 'Tema',
    'dark_mode': 'Karanlık Mod',
    'light_mode': 'Aydınlık Mod',
    'save': 'Kaydet',
    
    // Navigation
    'back': 'Geri',
    
    // Zorluk seçimi
    'select_difficulty': 'Zorluk Seçin',
    'choose_challenge': 'Zorluk seviyenizi seçin',
    'easy': 'Kolay',
    'easy_desc': 'Başlangıç için',
    'easy_pairs': '6 çift kart',
    'medium': 'Orta',
    'medium_desc': 'Normal zorluk',
    'medium_pairs': '10 çift kart',
    'hard': 'Zor',
    'hard_desc': 'Hafıza ustaları için',
    'hard_pairs': '15 çift kart',
    'expert': 'Uzman',
    'expert_desc': 'En zorlu seviye',
    'expert_pairs': '20 çift kart',
    'locked': 'KİLİTLİ',
    'feature_locked': 'Özellik Kilitli',
    'locked_description': 'Bu zorluk seviyesi gelecek güncellemelerde açılacak! Önce diğer zorluk seviyelerindeki görevleri tamamlayın.',
    'ok_got_it': 'TAMAM, ANLADIM',
    
    // Oyun ekranı
    'loading_cards': 'Kartlar Yükleniyor...',
    'congratulations': 'Tebrikler!',
    'game_completed': 'Oyunu tamamladınız! 🎉',
    'time': 'Süre:',
    'score': 'Skor:',
    'points': 'puan',
    'moves': 'Hamle:',
    'moves_value': 'hamle',
    'difficulty': 'Zorluk:',
    'play_again': 'Tekrar Oyna',
    'main_menu': 'Ana Menü',
    'exit_game': 'Oyundan Çık',
    'exit_confirm': 'Çıkmak istediğinize emin misiniz? İlerlemeniz kaydedilmeyecek.',
    'cancel': 'İptal',
    'exit': 'Çıkış',
    
    // Öğretici
    'tutorial_title': 'Nasıl Oynanır',
    'tutorial_step1_title': 'Oyunun Amacı',
    'tutorial_step1_desc': 'Oyunu tamamlamak için tüm kart çiftlerini eşleştirin. Ne kadar hızlı ve az hamle ile eşleştirirseniz, skorunuz o kadar yüksek olur!',
    'tutorial_step2_title': 'Nasıl Oynanır',
    'tutorial_step2_desc': 'Bir kartı açmak için üzerine dokunun. Sonra eşini bulmaya çalışın. Kartlar eşleşirse, açık kalırlar. Eşleşmezse, tekrar kapanırlar.',
    'tutorial_step3_title': 'Puanlama',
    'tutorial_step3_desc': 'Skor, hızınıza ve hamle sayınıza bağlıdır. Daha az hamle ve hızlı tamamlama daha yüksek puanlar kazandırır!',
    'tutorial_step4_title': 'Zorluk Seviyeleri',
    'tutorial_step4_desc': 'Kolay (6 çift), Orta (10 çift) veya Zor (15 çift) modlarından seçim yapın. Uzman modu geliştikçe açılır!',
    'next': 'İleri',
    'got_it': 'Anladım',
  });
}