import 'package:flutter/material.dart';

class SurtiLogo extends StatelessWidget {
  final bool isDark;
  final String? imageUrl;

  const SurtiLogo({super.key, this.isDark = false, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    // Si hay URL de imagen, mostrarla
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(
            color: isDark ? Colors.white : Colors.black,
            width: 3,
          ),
          borderRadius: BorderRadius.circular(18),
        ),
        child: imageUrl!.startsWith('assets/')
            ? Image.asset(
                imageUrl!,
                width: 200,
                height: 120,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return _buildLogoFallback();
                },
              )
            : Image.network(
                imageUrl!,
                width: 200,
                height: 120,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return _buildLogoFallback();
                },
              ),
      );
    }

    // Si no hay URL, mostrar logo de texto
    return _buildLogoFallback();
  }

  Widget _buildLogoFallback() {
    final isLogoWhite = isDark;
    final textColor = isLogoWhite ? Colors.white : Colors.black;
    final borderColor = isLogoWhite ? Colors.white : Colors.black;
    final bgColor = isLogoWhite ? Colors.black : Colors.white;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: bgColor,
        border: Border.all(color: borderColor, width: 3),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'SURTI',
            style: TextStyle(
              color: textColor,
              fontSize: 40,
              fontWeight: FontWeight.w900,
              letterSpacing: 3,
              height: 1,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'CAMISETAS',
            style: TextStyle(
              color: textColor,
              fontSize: 20,
              fontWeight: FontWeight.w900,
              letterSpacing: 2,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}
