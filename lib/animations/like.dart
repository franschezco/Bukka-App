import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';

import '../screens/checkout/cardpay.dart';
import '../screens/checkout/sucess/success.dart';

class LikeButtonAnimation extends StatefulWidget {
  @override
  _LikeButtonAnimationState createState() => _LikeButtonAnimationState();
}

class _LikeButtonAnimationState extends State<LikeButtonAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isLiked = false;
  late AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.5).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _audioPlayer = AudioPlayer();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _playSound() async {
    AudioPlayer().play(AssetSource('sound/like.mp3'));
  }

  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked;

      if (_isLiked) {
        _animationController.forward();
        _playSound();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleLike,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Icon(
          _isLiked ? Icons.favorite : Icons.favorite_border,
          color: _isLiked ? Colors.red : Colors.grey,
          size: 24.0,
        ),
      ),
    );
  }
}



class AddToCartAnimation extends StatefulWidget {
  @override
  _AddToCartAnimationState createState() => _AddToCartAnimationState();
}

class _AddToCartAnimationState extends State<AddToCartAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  bool _isAdded = false;
  late AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.5).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _rotationAnimation = Tween<double>(begin: 0.0, end: 2 * 3.14159).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _isAdded = true;
        });
        _playSound();
      }
    });

    _audioPlayer = AudioPlayer();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _playSound() async {
    AudioPlayer().play(AssetSource('sound/like.mp3'));
  }

  void _toggleCart() {
    setState(() {
      if (!_isAdded) {
        _animationController.forward(from: 0.0);
      } else {
        _isAdded = false;
        _animationController.reverse(from: 1.0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleCart,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Transform.rotate(
              angle: _rotationAnimation.value,
              child: Icon(
                _isAdded ? Icons.check : Icons.add_shopping_cart,
                color: Colors.green,
                size: 30.0,
              ),
            ),
          );
        },
      ),
    );
  }
}

class LoadingButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;
  final String buttonText;

  const LoadingButton({
    required this.isLoading,
    required this.onPressed,
    required this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: LinearGradient(
          colors: [Colors.yellow, Colors.orange],
        ),
      ),
      child: MaterialButton(
        minWidth: double.infinity,
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            strokeWidth: 2,
          ),
        )
            : Text(
          buttonText,
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Roboto',
          ),
        ),
      ),
    );
  }
}


class RadioSelectContainer extends StatefulWidget {
  @override
  _RadioSelectContainerState createState() => _RadioSelectContainerState();
}

class _RadioSelectContainerState extends State<RadioSelectContainer> {
  int? selectedValue;

  void handleRadioValueChanged(int? value) {
    setState(() {
      selectedValue = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select an option:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          RadioListTile<int?>(
            value: 1,
            groupValue: selectedValue,
            onChanged: handleRadioValueChanged,
            title: Text('Option 1'),
          ),
          RadioListTile<int?>(
            value: 2,
            groupValue: selectedValue,
            onChanged: handleRadioValueChanged,
            title: Text('Option 2'),
          ),
          RadioListTile<int?>(
            value: 3,
            groupValue: selectedValue,
            onChanged: handleRadioValueChanged,
            title: Text('Option 3'),
          ),
          SizedBox(height: 20),
          Text(
            'Selected value: ${selectedValue ?? ''}',
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}


class PaymentSelectionContainer extends StatefulWidget {
  @override
  _PaymentSelectionContainerState createState() =>
      _PaymentSelectionContainerState();
}

class _PaymentSelectionContainerState extends State<PaymentSelectionContainer> {
  String selectedMethod = '';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25,right: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                selectedMethod = 'Card';
                const delayDuration = Duration(milliseconds: 30);

                Future.delayed(delayDuration, () {
                  // Call your function here
                  Get.to(
                        () => CardPayScreen(),
                    transition: Transition.leftToRightWithFade,
                  );
                });
              });
            },
            child: Container(
              width: 150,
              height: 100,
              decoration: BoxDecoration(
                color: selectedMethod == 'Card' ? Colors.black : Colors.white60,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: selectedMethod == 'Card'
                        ? Colors.blue.withOpacity(0.3)
                        : Colors.grey.withOpacity(0.3),
                    blurRadius: 5,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.credit_card,
                    size: 40,
                    color: selectedMethod == 'Card'
                        ? Colors.white
                        : Colors.black,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Pay with Card',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: selectedMethod == 'Card'
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          GestureDetector(
            onTap: () {
              setState(() {
                selectedMethod = 'Cash on Delivery';
                const delayDuration = Duration(milliseconds: 30);

                Future.delayed(delayDuration, () {
                  // Call your function here
                  Get.to(
                        () => SuccessScreen(),
                    transition: Transition.leftToRightWithFade,
                  );
                });
              });
            },
            child: Container(
              width: 150,
              height: 100,
              decoration: BoxDecoration(
                color: selectedMethod == 'Cash on Delivery'
                    ? Colors.black
                    : Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: selectedMethod == 'Cash on Delivery'
                        ? Colors.blue.withOpacity(0.3)
                        : Colors.grey.withOpacity(0.3),
                    blurRadius: 5,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.local_shipping,
                    size: 40,
                    color: selectedMethod == 'Cash on Delivery'
                        ? Colors.white
                        : Colors.black,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Cash on Delivery',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: selectedMethod == 'Cash on Delivery'
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
class CustomCircularProgressIndicator extends StatefulWidget {
  final double speed;

  const CustomCircularProgressIndicator({Key? key, this.speed = 1.0}) : super(key: key);

  @override
  _CustomCircularProgressIndicatorState createState() =>
      _CustomCircularProgressIndicatorState();
}

class _CustomCircularProgressIndicatorState
    extends State<CustomCircularProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _colorAnimation = TweenSequence<Color?>([
      TweenSequenceItem(
        tween: ColorTween(begin: Colors.yellow, end: Colors.yellow),
        weight: 0.5,
      ),
      TweenSequenceItem(
        tween: ColorTween(begin: Colors.yellow, end: Colors.black),
        weight: 0.5,
      ),
    ]).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    ));

    _controller.repeat(
      period: Duration(seconds: (2 / widget.speed).round()),
    );
  }

  @override
  void didUpdateWidget(covariant CustomCircularProgressIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.speed != widget.speed) {
      _controller.duration = const Duration(seconds: 2);
      _controller.repeat(
        period: Duration(seconds: (2 / widget.speed).round()),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color?>(_colorAnimation.value),
        );
      },
    );
  }
}
