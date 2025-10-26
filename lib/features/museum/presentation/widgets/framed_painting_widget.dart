import 'package:flutter/material.dart';
import 'package:cultara/features/museum/domain/entities/museum.dart'; 

class FramedPainting extends StatelessWidget {
  final Museum museum;

  const FramedPainting({super.key, required this.museum});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final frameWidth = screenWidth * 0.75;
    final frameHeight = frameWidth * 1.07;

    return Center(
      child: SizedBox(
        width: frameWidth,
        height: frameHeight,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Shadow di belakang
            Positioned(
              top: frameHeight * 0.03,
              child: Container(
                width: frameWidth * 0.93,
                height: frameHeight * 0.93,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
              ),
            ),
            Positioned.fill(
              child: Image.asset(
                'assets/images/frame_digital.jpg',
                fit: BoxFit.contain,
              ),
            ),
            Positioned(
              left: frameWidth * 0.21,
              right: frameWidth * 0.21,
              top: frameHeight * 0.09,
              bottom: frameHeight * 0.08,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Image.network(
                  museum.image,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                            : null,
                        color: const Color(0xFFB71C1C),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey.shade300,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.broken_image,
                            size: 50,
                            color: Colors.grey.shade600,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Gambar tidak dapat dimuat',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



// import 'package:flutter/material.dart';
// import 'package:cultara/model/Museum.dart';

// class FramedPainting extends StatelessWidget {
//   final Museum museum;
//   final double width;
//   final double height;

//   const FramedPainting({
//     super.key,
//     required this.museum,
//     this.width = 280,
//     this.height = 300,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: width,
//       height: height,
//       child: Stack(
//         alignment: Alignment.center,
//         children: [
//           Positioned(
//             top: 32,
//             left: 32,
//             right: 32,
//             child: Container(
//               width: width,
//               height: height,
//               decoration: BoxDecoration(
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.4),
//                     blurRadius: 25,
//                     spreadRadius: 3,
//                     offset: const Offset(0, 10),
//                   ),
//                 ],
//               ),
//             ),
//           ),

//           Image.asset(
//             'assets/images/frame_digital.jpg',
//             width: width,
//             height: height,
//             fit: BoxFit.fill,
//           ),

//           Positioned(
//             top: 30,
//             bottom: 27,
//             left: 34,
//             right: 32,
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(6),
//               child: Image.asset(
//                 museum.image,
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

