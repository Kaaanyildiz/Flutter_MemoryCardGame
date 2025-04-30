import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:memorycardgame/memory_game/models/settings_provider.dart';
import 'package:provider/provider.dart';

class CardModel {
  final String id;
  final String content;
  final int pairId; // Her eşleşme çifti için benzersiz bir ID

  CardModel({required this.id, required this.content, required this.pairId});
}

class MemoryGameScreen extends StatefulWidget {
  final int pairCount;
  final String difficultyLevel;

  const MemoryGameScreen({
    super.key,
    required this.pairCount,
    required this.difficultyLevel,
  });

  @override
  State<MemoryGameScreen> createState() => MemoryGameScreenState();
}

class MemoryGameScreenState extends State<MemoryGameScreen>
    with TickerProviderStateMixin {
  List<CardModel> _cards = [];
  List<bool> _flipped = [];
  List<bool> _matched = [];
  bool _isLoading = true;
  bool _isProcessing = false;
  
  // Düzenlenen ve eklenen değişkenler
  int _score = 0;
  int _moves = 0;
  final int _matchScore = 10; // Her eşleşme için kazanılacak puan
  
  // Seçilen ve eşleşen kartları takip eden listeler
  List<int> _selectedCards = [];
  List<int> _flippedCards = [];
  List<int> _matchedCards = [];
  
  // Oyun zamanı ve süre takibi için
  late Stopwatch _stopwatch;
  late Timer _timer;
  String _formattedTime = "00:00";
  
  // Animasyon denetleyicileri
  late List<AnimationController> _flipControllers;
  late AnimationController _shakeController;
  late AnimationController _matchController;
  late AnimationController _timeController;
  late AnimationController _confettiController; // Konfeti animasyon denetleyicisi
  
  // Konfeti efekti için
  bool _showConfetti = false;
  final List<Color> _confettiColors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.purple,
    Colors.orange,
    Colors.pink,
  ];
  final List<ConfettiParticle> _confettiParticles = [];
  final int _confettiCount = 100;
  
  // Sensör abonelikleri için liste
  final List<StreamSubscription> _sensorSubscriptions = [];

  // Emoji setleri
  final List<String> _emojiSet = [
    '😀', '😍', '🤩', '😎', '🐶', '🦊', '🦁', '🐯', 
    '🐮', '🐷', '🐸', '🐙', '🐢', '🦄', '🦋', '🌈',
    '🍎', '🍓', '🍒', '🍑', '🍇', '🍉', '🍊', '🍌',
    '🎸', '🎮', '🚗', '✈️', '🚀', '⚽', '🏀', '🎯'
  ];

  @override
  void initState() {
    super.initState();
    _resetGame();
    
    // Animation controllers
    _matchController = AnimationController(
      vsync: this, 
      duration: const Duration(milliseconds: 300),
    );
    
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    
    _timeController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    
    // Confetti controller başlatma
    _confettiController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );
    
    // Zaman takibi başlat
    _stopwatch = Stopwatch()..start();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _updateTimer();
        });
      }
    });
    
    // Kartları yükle
    _loadCards();
  }

  @override
  void dispose() {
    _timer.cancel();
    _stopwatch.stop();
    
    // Tüm controllerleri temizle
    for (final controller in _flipControllers) {
      controller.dispose();
    }
    _shakeController.dispose();
    _matchController.dispose();
    _timeController.dispose();
    _confettiController.dispose();
    
    // Sensörleri kapat
    for (final subscription in _sensorSubscriptions) {
      subscription.cancel();
    }
    
    super.dispose();
  }

  void _updateTimer() {
    final minutes = (_stopwatch.elapsedMilliseconds ~/ 60000).toString().padLeft(2, '0');
    final seconds = ((_stopwatch.elapsedMilliseconds ~/ 1000) % 60).toString().padLeft(2, '0');
    setState(() {
      _formattedTime = "$minutes:$seconds";
    });
  }

  Future<void> _loadCards() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Basit bir gecikme ekleyerek kart yükleme hissi veriyoruz
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Kartları doğrudan burada oluşturuyoruz
      final cards = _generateCards(widget.pairCount);
      
      setState(() {
        _cards = cards;
        _flipped = List.generate(cards.length, (index) => false);
        _matched = List.generate(cards.length, (index) => false);
        
        // Kart çevirme animasyon denetleyicileri
        _flipControllers = List.generate(
          cards.length,
          (index) => AnimationController(
            duration: const Duration(milliseconds: 400),
            vsync: this,
          ),
        );
        
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // Hata işleme
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading cards: $e')),
      );
    }
  }
  
  // Kartları oluşturan metod
  List<CardModel> _generateCards(int pairCount) {
    final random = Random();
    
    // Belirtilen çift sayısı kadar emoji seçiyoruz
    final List<String> shuffledEmojis = List<String>.from(_emojiSet);
    shuffledEmojis.shuffle(random);
    final selectedEmojis = shuffledEmojis.take(pairCount).toList();

    // Her emoji için 2 kart oluşturuyoruz (eşleşme için)
    final cardsList = <CardModel>[];
    for (int i = 0; i < pairCount; i++) {
      final emoji = selectedEmojis[i];
      // Her çifte benzersiz bir pairId atıyoruz
      // Birinci kart
      cardsList.add(CardModel(
        id: 'card_${i}_1',
        content: emoji,
        pairId: i,
      ));
      // Eşleşen ikinci kart
      cardsList.add(CardModel(
        id: 'card_${i}_2',
        content: emoji,
        pairId: i,
      ));
    }
    
    // Gelişmiş karıştırma algoritması
    return _shuffleCardsAdvanced(cardsList, _getGridSize(widget.difficultyLevel));
  }

  // Gelişmiş kart karıştırma algoritması
  List<CardModel> _shuffleCardsAdvanced(List<CardModel> cards, int gridSize) {
    final random = Random.secure(); // Daha güvenli rastgele sayı üreteci
    final int totalCards = cards.length;
    final List<CardModel> result = List<CardModel>.from(cards);
    
    // 1. Adım: Çoklu Fisher-Yates karıştırma (birden fazla kez karıştır)
    for (int iteration = 0; iteration < 3; iteration++) {
      for (int i = totalCards - 1; i > 0; i--) {
        int j = random.nextInt(i + 1);
        // Değiş tokuş (swap)
        CardModel temp = result[i];
        result[i] = result[j];
        result[j] = temp;
      }
    }
    
    // 2. Adım: Tüm eşleşen çiftlerin birbirine çok yakın olmamasını sağla
    Map<int, List<int>> pairPositions = {};
    
    // Her çiftin konumlarını bul
    for (int i = 0; i < totalCards; i++) {
      int pairId = result[i].pairId;
      if (pairPositions[pairId] == null) {
        pairPositions[pairId] = [];
      }
      pairPositions[pairId]!.add(i);
    }

    // Her zorluk seviyesi için minimum uzaklık belirle
    int minDesiredDistance;
    switch (gridSize) {
      case 4: // Kolay seviye
        minDesiredDistance = 3;
        break;
      case 5: // Orta seviye
        minDesiredDistance = 4; 
        break;
      default: // Zor ve üzeri
        minDesiredDistance = 5;
    }

    // 3. Adım: 10 iyileştirme denemesi yap
    for (int attempt = 0; attempt < 10; attempt++) {
      bool madeChanges = false;
      
      // Her çift için kontrol et
      for (int pairId in pairPositions.keys) {
        if (pairPositions[pairId]!.length == 2) {
          int pos1 = pairPositions[pairId]![0];
          int pos2 = pairPositions[pairId]![1];
          
          // 2D grid'de pozisyonları bul
          int row1 = pos1 ~/ gridSize;
          int col1 = pos1 % gridSize;
          int row2 = pos2 ~/ gridSize;
          int col2 = pos2 % gridSize;
          
          // Manhattan mesafesi
          int distance = (row1 - row2).abs() + (col1 - col2).abs();
          
          // Diagonal komşuluk kontrolü (daha yakın oldukları durumları tespit et)
          bool isDiagonallyClose = ((row1 - row2).abs() <= 1 && (col1 - col2).abs() <= 1);
          
          // Eğer kartlar çok yakınsa veya diagonal komşuysa değiştir
          if (distance < minDesiredDistance || isDiagonallyClose) {
            // Mevcut kartla değiştirilecek en iyi kart pozisyonunu bul
            int bestSwapPosition = -1;
            int maxResultingDistance = -1;
            
            // 10 rastgele kart pozisyonu dene ve en iyisini seç
            for (int tryCount = 0; tryCount < 10; tryCount++) {
              int swapIdx = random.nextInt(totalCards);
              
              // Aynı çiftten biriyle değiştirme
              if (result[swapIdx].pairId != pairId) {
                // Pozisyonu grid'de bul
                int swapRow = swapIdx ~/ gridSize;
                int swapCol = swapIdx % gridSize;
                
                // Değiştirme sonrası yeni mesafeyi hesapla
                int newDistance1 = (row1 - swapRow).abs() + (col1 - swapCol).abs();
                int newDistance2 = (swapRow - row2).abs() + (swapCol - col2).abs();
                int minNewDistance = newDistance1 < newDistance2 ? newDistance1 : newDistance2;
                
                // Daha iyi bir mesafe elde edilebilirse kullan
                if (minNewDistance > maxResultingDistance) {
                  maxResultingDistance = minNewDistance;
                  bestSwapPosition = swapIdx;
                }
              }
            }
            
            // En iyi pozisyon bulunduysa değiştir
            if (bestSwapPosition != -1 && maxResultingDistance > distance) {
              // Değiştirme işlemi
              int swapIdx = bestSwapPosition;
              CardModel temp = result[pos2];
              result[pos2] = result[swapIdx];
              result[swapIdx] = temp;
              
              // pairPositions güncellemesi
              pairPositions[pairId]![1] = swapIdx;
              int swapPairId = result[pos2].pairId;
              
              for (int j = 0; j < pairPositions[swapPairId]!.length; j++) {
                if (pairPositions[swapPairId]![j] == swapIdx) {
                  pairPositions[swapPairId]![j] = pos2;
                  break;
                }
              }
              
              madeChanges = true;
            }
          }
        }
      }
      
      // Hiç değişiklik yapılmadıysa döngüden çık
      if (!madeChanges) {
        break;
      }
    }
    
    return result;
  }
  
  void _onCardTap(int index) {
    // Eğer kart zaten eşleşmiş, ters çevrilmiş ya da seçilmiş durumdaysa işlem yapma
    if (_matchedCards.contains(index) ||
        _flippedCards.contains(index) ||
        _selectedCards.contains(index) ||
        _isProcessing) {
      return;
    }

    setState(() {
      // Kartı seçilen kartlar listesine ekle ve animasyonu başlat
      _selectedCards.add(index);
      _flipControllers[index].forward();
      _flipped[index] = true;

      // Hamle sayısını artır
      _moves++;

      // İlk seçilen kart ise, ikinci kartı bekle
      if (_selectedCards.length == 1) {
        _flippedCards.add(index);
      } 
      // İkinci kart seçildiğinde
      else if (_selectedCards.length == 2) {
        _isProcessing = true;
        final firstIndex = _selectedCards[0];
        final secondIndex = _selectedCards[1];

        // İki kartın sembolü eşleşiyorsa
        if (_cards[firstIndex].pairId == _cards[secondIndex].pairId) {
          // Eşleşen kartlar için puan ekle
          _score += _matchScore;
          
          // Eşleşen kartları listeye ekle
          _matchedCards.add(firstIndex);
          _matchedCards.add(secondIndex);
          _matched[firstIndex] = true;
          _matched[secondIndex] = true;
          
          // Eşleşme animasyonunu başlat
          _matchController.reset();
          _matchController.forward();

          // Tüm kartlar eşleştiyse oyun tamamlandı
          if (_matchedCards.length == _cards.length) {
            // Oyun tamamlandı, confetti animasyonunu başlat
            _gameCompleted();
          }
          
          // İşlemi tamamla
          Future.delayed(const Duration(milliseconds: 500), () {
            if (mounted) {
              setState(() {
                _isProcessing = false;
                _selectedCards.clear();
              });
            }
          });
        } 
        // Kartlar eşleşmiyorsa
        else {
          // Sallanma animasyonunu başlat
          _shakeController.reset();
          _shakeController.forward();
          
          // Kartları geri çevirmek için zamanlayıcı başlat
          Future.delayed(const Duration(milliseconds: 800), () {
            if (mounted) {
              setState(() {
                // Seçilmiş kartlar için animasyonu ters çevir
                _flipControllers[firstIndex].reverse();
                _flipControllers[secondIndex].reverse();
                _flipped[firstIndex] = false;
                _flipped[secondIndex] = false;
              });
            }
          });
          
          // Kart çevrildikten sonra listelerden kaldır
          Future.delayed(const Duration(milliseconds: 1200), () {
            if (mounted) {
              setState(() {
                _flippedCards.remove(firstIndex);
                _flippedCards.remove(secondIndex);
                _selectedCards.clear();
                _isProcessing = false;
              });
            }
          });
        }
      }
    });
  }
  
  void _gameCompleted() {
    _stopwatch.stop();
    _timer.cancel();
    _showConfetti = true;
    
    // Konfeti parçacıklarını oluştur
    final random = Random();
    for (int i = 0; i < _confettiCount; i++) {
      _confettiParticles.add(
        ConfettiParticle(
          color: _confettiColors[random.nextInt(_confettiColors.length)],
          position: Offset(random.nextDouble() * MediaQuery.of(context).size.width, -20),
          speed: 2 + random.nextDouble() * 4,
          radius: 5 + random.nextDouble() * 5,
          angle: random.nextDouble() * pi / 1.5 + pi / 6,
        ),
      );
    }
    
    // Oyun tamamlandı diyaloğunu göster
    Future.delayed(const Duration(milliseconds: 1000), () {
      _showCompletionDialog();
    });
  }
  
  void _showCompletionDialog() {
    final settingsProvider = Provider.of<SettingsProvider>(context, listen: false);
    final lang = settingsProvider.language;
    final isDark = settingsProvider.isDarkMode;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => PopScope(
        canPop: false,
        child: AlertDialog(
          backgroundColor: isDark ? Colors.grey.shade900 : Colors.white,
          title: Row(
            children: [
              const Icon(Icons.emoji_events, color: Colors.amber, size: 30),
              const SizedBox(width: 10),
              Text(
                lang.get('congratulations'),
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                lang.get('game_completed'),
                style: TextStyle(color: isDark ? Colors.white70 : Colors.black87),
              ),
              const SizedBox(height: 20),
              _buildStatRow(lang.get('time'), _formattedTime, isDark),
              _buildStatRow(lang.get('score'), '${_score} ${lang.get('points')}', isDark),
              _buildStatRow(lang.get('moves'), '$_moves ${lang.get('moves_value')}', isDark),
              const SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    '${lang.get('difficulty')}: ',
                    style: TextStyle(color: isDark ? Colors.white70 : Colors.black87),
                  ),
                  _buildDifficultyBadge(widget.difficultyLevel),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Yeniden başlat
                Navigator.of(context).pop();
                _restartGame();
              },
              child: Text(
                lang.get('play_again'),
                style: TextStyle(color: isDark ? Colors.cyan : Colors.blue),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Ana menüye dön
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isDark ? Colors.cyan : Colors.blue,
              ),
              child: Text(
                lang.get('main_menu'),
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
  
  Widget _buildStatRow(String label, String value, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label, 
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: isDark ? Colors.white70 : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildDifficultyBadge(String difficultyLevel) {
    final settingsProvider = Provider.of<SettingsProvider>(context, listen: false);
    final lang = settingsProvider.language;
    
    Color color;
    String label;
    
    switch (difficultyLevel) {
      case 'easy':
        color = Colors.green;
        label = lang.get('easy');
        break;
      case 'medium':
        color = Colors.orange;
        label = lang.get('medium');
        break;
      case 'hard':
        color = Colors.red;
        label = lang.get('hard');
        break;
      case 'expert':
        color = Colors.purple;
        label = lang.get('expert');
        break;
      default:
        color = Colors.blue;
        label = difficultyLevel;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
    );
  }
  
  void _resetGame() {
    _cards = [];
    _flipped = [];
    _matched = [];
    _selectedCards = [];
    _flippedCards = [];
    _matchedCards = [];
    _score = 0;
    _moves = 0;
    _isProcessing = false;
    _showConfetti = false;
    _confettiParticles.clear();
  }

  void _restartGame() {
    setState(() {
      _resetGame();
      
      // Süre takibini yeniden başlat
      if (_stopwatch.isRunning) {
        _stopwatch.stop();
      }
      _stopwatch = Stopwatch()..start();
      
      if (_timer.isActive) {
        _timer.cancel();
      }
      
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (mounted) {
          setState(() {
            _updateTimer();
          });
        }
      });
    });
    
    _loadCards();
  }
  
  void _showExitDialog() {
    final settingsProvider = Provider.of<SettingsProvider>(context, listen: false);
    final lang = settingsProvider.language;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(lang.get('exit_game')),
        content: Text(lang.get('exit_confirm')),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Diyaloğu kapat
            },
            child: Text(lang.get('cancel')),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(); // Diyaloğu kapat
              Navigator.of(context).pop(); // Oyun sayfasından çık
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: Text(lang.get('exit')),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);
    final lang = settingsProvider.language;
    final isDark = settingsProvider.isDarkMode;
    
    List<Color> gradientColors = isDark ? 
      [
        Colors.deepPurple.shade900,
        Colors.indigo.shade800,
        Colors.blue.shade900,
      ] : 
      [
        Colors.blue.shade400,
        Colors.cyan.shade300,
        Colors.lightBlue.shade200,
      ];

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isDark 
                  ? Colors.white.withAlpha(51) // 0.2 alpha for dark mode
                  : Colors.black.withAlpha(38), // 0.15 alpha for light mode
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.arrow_back_ios_new,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          onPressed: () {
            // Oyundan çıkma diyaloğunu göster
            _showExitDialog();
          },
        ),
        actions: [
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isDark 
                    ? Colors.white.withAlpha(51) // 0.2 alpha for dark mode
                    : Colors.black.withAlpha(38), // 0.15 alpha for light mode
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.refresh,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            onPressed: () {
              _restartGame();
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradientColors,
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Üst bilgi paneli
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: _buildInfoPanel(),
              ),
              
              // Kart görünümü
              Positioned(
                top: 80,
                left: 0,
                right: 0,
                bottom: 0,
                child: _isLoading
                    ? _buildLoadingView()
                    : _buildCardGrid(),
              ),
              
              // Konfeti efekti
              if (_showConfetti)
                Positioned.fill(
                  child: CustomPaint(
                    painter: ConfettiPainter(_confettiParticles),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoPanel() {
    final settingsProvider = Provider.of<SettingsProvider>(context);
    final lang = settingsProvider.language;
    
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(38), // 0.15 -> 38/255
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(77), // 0.3 -> 77/255
            blurRadius: 5,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Süre
          Row(
            children: [
              const Icon(Icons.timer, color: Colors.white70, size: 20),
              const SizedBox(width: 5),
              Text(
                _formattedTime,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          
          // Hamle sayısı
          Row(
            children: [
              const Icon(Icons.touch_app, color: Colors.white70, size: 20),
              const SizedBox(width: 5),
              Text(
                '$_moves',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          
          // Puan
          Row(
            children: [
              const Icon(Icons.star, color: Colors.white70, size: 20),
              const SizedBox(width: 5),
              Text(
                '$_score',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildLoadingView() {
    final settingsProvider = Provider.of<SettingsProvider>(context);
    final lang = settingsProvider.language;
    
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(
            color: Colors.white,
          ),
          const SizedBox(height: 20),
          Text(
            lang.get('loading_cards'),
            style: TextStyle(
              color: Colors.white.withAlpha(204), // 0.8 alpha
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildCardGrid() {
    // Zorluk seviyesine göre grid boyutunu belirle
    final int gridSize = _getGridSize(widget.difficultyLevel);

    // Farklı zorluk seviyeleri için özel grid düzenleri
    SliverGridDelegateWithFixedCrossAxisCount gridDelegate;
    
    if (widget.difficultyLevel == 'hard') {
      // Zor mod için 5x6 grid - 15 çift (30 kart) için optimize edilmiş
      gridDelegate = const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,  // 5 sütun
        childAspectRatio: 0.75,  // Biraz daha uzun kartlar
        crossAxisSpacing: 6,  // Daha az boşluk
        mainAxisSpacing: 6,
      );
    } else if (widget.difficultyLevel == 'expert') {
      // Uzman mod için 6x6 grid (16 çift = 32 kart)
      gridDelegate = const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 6,  
        childAspectRatio: 0.85,
        crossAxisSpacing: 6,
        mainAxisSpacing: 6,
      );
    } else {
      // Diğer zorluk seviyeleri için standart grid
      gridDelegate = SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: gridSize,
        childAspectRatio: 1.0,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      );
    }
    
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: AnimationLimiter(
        child: GridView.builder(
          gridDelegate: gridDelegate,
          itemCount: _cards.length,
          itemBuilder: (context, index) {
            return AnimationConfiguration.staggeredGrid(
              position: index,
              duration: const Duration(milliseconds: 500),
              columnCount: widget.difficultyLevel == 'hard' ? 5 : 
                         widget.difficultyLevel == 'expert' ? 6 : gridSize,
              child: FadeInAnimation(
                child: SlideAnimation(
                  child: _buildCard(index),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
  
  Widget _buildCard(int index) {
    final settingsProvider = Provider.of<SettingsProvider>(context);
    
    // Zorluk seviyesine göre emoji boyutunu ayarla
    double emojiSize;
    switch (widget.difficultyLevel) {
      case 'easy':
        emojiSize = 40.0;
        break;
      case 'medium':
        emojiSize = 36.0;
        break;
      case 'hard':
      case 'expert':
        emojiSize = 32.0;
        break;
      default:
        emojiSize = 40.0;
    }

    // Kartın içeriği: kapalı veya açık durumuna göre
    Widget cardContent = _flipped[index] 
      ? Center(
          child: Text(
            _cards[index].content,
            style: TextStyle(
              fontSize: emojiSize,
            ),
          ),
        )
      : Center(
          child: Icon(
            Icons.help_outline,
            size: 36,
            color: settingsProvider.isDarkMode ? Colors.white70 : Colors.white,
          ),
        );

    // Kart içeriğini animasyon ile sarmala
    if (_flipped[index]) {
      cardContent = cardContent
        .animate(key: ValueKey('flip_${index}_${_flipped[index]}'))
        .scale(
          begin: const Offset(0.0, 0.0),
          end: const Offset(1.0, 1.0),
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOutBack,
        )
        .fade(
          begin: 0.0,
          end: 1.0, 
          duration: const Duration(milliseconds: 100),
        );
    }

    return GestureDetector(
      onTap: () => _onCardTap(index),
      child: AnimatedBuilder(
        animation: _shakeController,
        builder: (context, child) {
          // Sallanma animasyonu
          double dx = 0.0;
          if (_selectedCards.length == 2 && 
              _selectedCards.contains(index) &&
              _cards[_selectedCards[0]].pairId != _cards[_selectedCards[1]].pairId) {
            dx = sin(_shakeController.value * pi * 8) * 5;
          }
          
          return Transform.translate(
            offset: Offset(dx, 0),
            child: child,
          );
        },
        child: AnimatedBuilder(
          animation: _matchController,
          builder: (context, child) {
            // Eşleşme animasyonu
            double scale = 1.0;
            if (_matchedCards.contains(index) && !_matchController.isCompleted) {
              scale = 1.0 + sin(_matchController.value * pi) * 0.1;
            }
            
            return Transform.scale(
              scale: scale,
              child: child,
            );
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              color: _getCardColor(index, settingsProvider.isDarkMode),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(50),
                  blurRadius: 4,
                  offset: const Offset(2, 2),
                ),
              ],
            ),
            child: cardContent,
          ),
        ),
      ),
    );
  }
  
  Color _getCardColor(int index, bool isDarkMode) {
    if (_matched[index]) {
      // Eşleşen kart
      return Colors.green.shade500;
    } else if (_flipped[index]) {
      // Çevrilmiş kart
      return isDarkMode ? Colors.blue.shade600 : Colors.blue.shade300;
    } else {
      // Normal kart
      return isDarkMode ? Colors.blueGrey.shade700 : Colors.blue.shade600;
    }
  }
  
  int _getGridSize(String difficultyLevel) {
    switch (difficultyLevel) {
      case 'easy':
        return 4; // 4x3 grid (6 çift = 12 kart)
      case 'medium':
        return 5; // 5x4 grid (10 çift = 20 kart)
      case 'hard':
        return 5; // 5x5 grid (12 çift = 24 kart) - daha az sütun ile daha büyük kartlar
      case 'expert':
        return 6; // 6x6 grid (16 çift = 32 kart) - optimum kart boyutu için ayarlandı
      default:
        return 4;
    }
  }
}

// Konfeti parçacığı sınıfı
class ConfettiParticle {
  Offset position;
  final double speed;
  final double radius;
  final Color color;
  final double angle;
  
  ConfettiParticle({
    required this.position,
    required this.speed,
    required this.radius,
    required this.color,
    required this.angle,
  });
  
  void update() {
    final dx = cos(angle) * speed;
    final dy = sin(angle) * speed + 0.2; // Yerçekimi etkisi
    position = Offset(position.dx + dx, position.dy + dy);
  }
}

// Konfeti efekti için CustomPainter
class ConfettiPainter extends CustomPainter {
  final List<ConfettiParticle> particles;
  
  ConfettiPainter(this.particles);
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill;
    
    // Tüm parçacıkları güncelle ve çiz
    for (final particle in particles) {
      particle.update();
      paint.color = particle.color;
      
      canvas.drawCircle(particle.position, particle.radius, paint);
    }
  }
  
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}