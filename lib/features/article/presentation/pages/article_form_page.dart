import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/article.dart';
import '../../data/models/article_model.dart';
import '../providers/article_provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class ArticleFormPage extends StatefulWidget {
  final Article? article; // null = create, not null = edit

  const ArticleFormPage({super.key, this.article});

  @override
  State<ArticleFormPage> createState() => _ArticleFormPageState();
}

class _ArticleFormPageState extends State<ArticleFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _imagePathController = TextEditingController();
  final _briefController = TextEditingController();
  final List<TextEditingController> _galleryControllers = [];

  String? _selectedCategory;
  String? _selectedProvince;
  bool _isLoading = false;

  // Daftar 38 Provinsi di Indonesia
  final List<String> _provinces = [
    'Aceh',
    'Sumatera Utara',
    'Sumatera Barat',
    'Riau',
    'Kepulauan Riau',
    'Jambi',
    'Sumatera Selatan',
    'Kepulauan Bangka Belitung',
    'Bengkulu',
    'Lampung',
    'DKI Jakarta',
    'Banten',
    'Jawa Barat',
    'Jawa Tengah',
    'DI Yogyakarta',
    'Jawa Timur',
    'Bali',
    'Nusa Tenggara Barat',
    'Nusa Tenggara Timur',
    'Kalimantan Barat',
    'Kalimantan Tengah',
    'Kalimantan Selatan',
    'Kalimantan Timur',
    'Kalimantan Utara',
    'Sulawesi Utara',
    'Sulawesi Tengah',
    'Sulawesi Selatan',
    'Sulawesi Tenggara',
    'Gorontalo',
    'Sulawesi Barat',
    'Maluku',
    'Maluku Utara',
    'Papua',
    'Papua Barat',
    'Papua Tengah',
    'Papua Pegunungan',
    'Papua Selatan',
    'Papua Barat Daya',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.article != null) {
      _titleController.text = widget.article!.title;
      _selectedCategory = widget.article!.category;
      _selectedProvince = widget.article!.location;
      _contentController.text = widget.article!.content;
      _imagePathController.text = widget.article!.imagePath;
      _briefController.text = widget.article!.brief;

      // Initialize gallery controllers
      for (var i = 0; i < widget.article!.galleryImages.length; i++) {
        final controller = TextEditingController(
          text: widget.article!.galleryImages[i],
        );
        _galleryControllers.add(controller);
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _imagePathController.dispose();
    _briefController.dispose();
    for (var controller in _galleryControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _addGalleryField() {
    if (_galleryControllers.length < 6) {
      setState(() {
        _galleryControllers.add(TextEditingController());
      });
    }
  }

  void _removeGalleryField(int index) {
    setState(() {
      _galleryControllers[index].dispose();
      _galleryControllers.removeAt(index);
    });
  }

  Future<void> _saveArticle() async {
    if (!_formKey.currentState!.validate()) return;

    // Validate province selection
    if (_selectedProvince == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Harap pilih provinsi'),
          backgroundColor: Color(0xFFB71C1C),
        ),
      );
      return;
    }

    final authProvider = context.read<AuthProvider>();
    final currentUser = authProvider.currentUser;

    if (currentUser == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('User not logged in')));
      return;
    }

    setState(() => _isLoading = true);

    try {
      final provider = context.read<ArticleProvider>();

      // Collect gallery images (remove empty ones)
      final galleryImages = _galleryControllers
          .map((controller) => controller.text.trim())
          .where((url) => url.isNotEmpty)
          .toList();

      final articleModel = ArticleModel(
        id: widget.article?.id ?? '',
        title: _titleController.text.trim(),
        category: _selectedCategory ?? '',
        location: _selectedProvince ?? '',
        content: _contentController.text.trim(),
        imagePath: _imagePathController.text.trim(),
        author: widget.article?.author ?? currentUser.name,
        createdAt: widget.article?.createdAt ?? DateTime.now(),
        views: widget.article?.views ?? 0,
        brief: _briefController.text.trim(),
        galleryImages: galleryImages,
      );

      if (widget.article == null) {
        await provider.createArticle(articleModel);
      } else {
        await provider.updateArticle(articleModel);
      }

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.article == null
                  ? 'Artikel berhasil ditambahkan'
                  : 'Artikel berhasil diupdate',
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final currentUser = authProvider.currentUser;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(widget.article == null ? 'Tambah Artikel' : 'Edit Artikel'),
        backgroundColor: const Color(0xFFB71C1C),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Form content
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 5,
                    blurRadius: 15,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    const Text(
                      'Judul Artikel',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFFB71C1C),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        hintText: 'Masukkan judul artikel',
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        filled: true,
                        fillColor: Colors.grey[50],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFFB71C1C),
                            width: 2,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Judul tidak boleh kosong';
                        }
                        if (value.length < 5) {
                          return 'Judul minimal 5 karakter';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Category
                    const Text(
                      'Kategori',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFFB71C1C),
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: _selectedCategory,
                      decoration: InputDecoration(
                        hintText: 'Pilih kategori',
                        filled: true,
                        fillColor: Colors.grey[50],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFFB71C1C),
                            width: 2,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'Tarian',
                          child: Text('Tarian'),
                        ),
                        DropdownMenuItem(value: 'Lagu', child: Text('Lagu')),
                      ],
                      onChanged: (String? value) {
                        setState(() {
                          _selectedCategory = value;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Kategori tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Province
                    const Text(
                      'Provinsi',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFFB71C1C),
                      ),
                    ),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: () => _showProvinceSearchDialog(),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                _selectedProvince ?? 'Pilih Provinsi',
                                style: TextStyle(
                                  color: _selectedProvince == null
                                      ? Colors.grey[600]
                                      : Colors.black,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            Icon(
                              Icons.arrow_drop_down,
                              color: Colors.grey[600],
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (_selectedProvince == null)
                      const Padding(
                        padding: EdgeInsets.only(top: 8, left: 16),
                        child: Text(
                          'Provinsi tidak boleh kosong',
                          style: TextStyle(color: Colors.red, fontSize: 12),
                        ),
                      ),
                    const SizedBox(height: 20),

                    // Image URL
                    const Text(
                      'URL Gambar',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFFB71C1C),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _imagePathController,
                      decoration: InputDecoration(
                        hintText: 'https://example.com/image.jpg',
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        filled: true,
                        fillColor: Colors.grey[50],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFFB71C1C),
                            width: 2,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {}); // Refresh to show image preview
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'URL gambar tidak boleh kosong';
                        }
                        if (!value.startsWith('http://') &&
                            !value.startsWith('https://')) {
                          return 'URL harus dimulai dengan http:// atau https://';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Image Preview
                    if (_imagePathController.text.isNotEmpty)
                      Container(
                        height: 200,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.network(
                            _imagePathController.text,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value:
                                      loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                      : null,
                                  color: const Color(0xFFB71C1C),
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey[200],
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.broken_image,
                                      size: 50,
                                      color: Colors.grey[600],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Gagal memuat gambar',
                                      style: TextStyle(color: Colors.grey[600]),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    if (_imagePathController.text.isNotEmpty)
                      const SizedBox(height: 20),

                    // Brief/Ringkasan
                    const Text(
                      'Ringkasan Singkat',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFFB71C1C),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      child: TextFormField(
                        controller: _briefController,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Tulis ringkasan singkat artikel...',
                          contentPadding: EdgeInsets.zero,
                          isDense: true,
                        ),
                        style: const TextStyle(fontSize: 16),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Ringkasan tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Gallery Images
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'URL Gambar Galeri (Maksimal 6)',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFFB71C1C),
                          ),
                        ),
                        if (_galleryControllers.length < 6)
                          IconButton(
                            icon: const Icon(
                              Icons.add_circle,
                              color: Color(0xFFB71C1C),
                            ),
                            onPressed: _addGalleryField,
                            tooltip: 'Tambah gambar',
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ...List.generate(_galleryControllers.length, (index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _galleryControllers[index],
                                decoration: InputDecoration(
                                  hintText:
                                      'https://example.com/gallery${index + 1}.jpg',
                                  hintStyle: TextStyle(color: Colors.grey[400]),
                                  filled: true,
                                  fillColor: Colors.grey[50],
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: Colors.grey[300]!,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: Colors.grey[300]!,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                      color: Color(0xFFB71C1C),
                                      width: 2,
                                    ),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 14,
                                  ),
                                ),
                                validator: (value) {
                                  if (value != null && value.isNotEmpty) {
                                    if (!value.startsWith('http://') &&
                                        !value.startsWith('https://')) {
                                      return 'URL harus dimulai dengan http:// atau https://';
                                    }
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              icon: const Icon(
                                Icons.remove_circle,
                                color: Colors.red,
                              ),
                              onPressed: () => _removeGalleryField(index),
                              tooltip: 'Hapus gambar',
                            ),
                          ],
                        ),
                      );
                    }),
                    if (_galleryControllers.isEmpty)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.photo_library, color: Colors.grey[600]),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Belum ada gambar galeri. Klik + untuk menambah.',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 20),

                    // Content (multiline)
                    const Text(
                      'Konten Artikel',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFFB71C1C),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _contentController,
                      decoration: InputDecoration(
                        hintText: 'Tulis konten artikel di sini...',
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        filled: true,
                        fillColor: Colors.grey[50],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFFB71C1C),
                            width: 2,
                          ),
                        ),
                        contentPadding: const EdgeInsets.all(16),
                        alignLabelWithHint: true,
                      ),
                      maxLines: 10,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Konten tidak boleh kosong';
                        }
                        if (value.length < 100) {
                          return 'Konten minimal 100 karakter';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Author Info (read-only)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.amber[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.amber[200]!),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.person,
                            color: Color(0xFFB71C1C),
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Penulis',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                                Text(
                                  widget.article?.author ??
                                      currentUser?.name ??
                                      'Unknown',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Save Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _saveArticle,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFB71C1C),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                          disabledBackgroundColor: Colors.grey[400],
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: Colors.white,
                                ),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    widget.article == null
                                        ? Icons.add_circle_outline
                                        : Icons.save_outlined,
                                    size: 24,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    widget.article == null
                                        ? 'Tambah Artikel'
                                        : 'Update Artikel',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showProvinceSearchDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ProvinceSearchDialog(
          provinces: _provinces,
          selectedProvince: _selectedProvince,
          onProvinceSelected: (String province) {
            setState(() {
              _selectedProvince = province;
            });
          },
        );
      },
    );
  }
}

// Province Search Dialog Widget
class ProvinceSearchDialog extends StatefulWidget {
  final List<String> provinces;
  final String? selectedProvince;
  final Function(String) onProvinceSelected;

  const ProvinceSearchDialog({
    super.key,
    required this.provinces,
    required this.selectedProvince,
    required this.onProvinceSelected,
  });

  @override
  State<ProvinceSearchDialog> createState() => _ProvinceSearchDialogState();
}

class _ProvinceSearchDialogState extends State<ProvinceSearchDialog> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _filteredProvinces = [];

  @override
  void initState() {
    super.initState();
    _filteredProvinces = widget.provinces;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterProvinces(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredProvinces = widget.provinces;
      } else {
        _filteredProvinces = widget.provinces
            .where(
              (province) =>
                  province.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.85,
        height: MediaQuery.of(context).size.height * 0.7,
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Header
            Row(
              children: [
                const Icon(
                  Icons.location_on,
                  color: Color(0xFFB71C1C),
                  size: 28,
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Pilih Provinsi',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFB71C1C),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Search Field
            TextField(
              controller: _searchController,
              onChanged: _filterProvinces,
              decoration: InputDecoration(
                hintText: 'Cari provinsi...',
                prefixIcon: const Icon(Icons.search, color: Color(0xFFB71C1C)),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _filterProvinces('');
                        },
                      )
                    : null,
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFFB71C1C),
                    width: 2,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Province List
            Expanded(
              child: _filteredProvinces.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Provinsi tidak ditemukan',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: _filteredProvinces.length,
                      itemBuilder: (context, index) {
                        final province = _filteredProvinces[index];
                        final isSelected = province == widget.selectedProvince;

                        return InkWell(
                          onTap: () {
                            widget.onProvinceSelected(province);
                            Navigator.pop(context);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            margin: const EdgeInsets.only(bottom: 8),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFFB71C1C).withOpacity(0.1)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: isSelected
                                    ? const Color(0xFFB71C1C)
                                    : Colors.grey[300]!,
                                width: isSelected ? 2 : 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.location_city,
                                  color: isSelected
                                      ? const Color(0xFFB71C1C)
                                      : Colors.grey[600],
                                  size: 20,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    province,
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                      color: isSelected
                                          ? const Color(0xFFB71C1C)
                                          : Colors.black87,
                                    ),
                                  ),
                                ),
                                if (isSelected)
                                  const Icon(
                                    Icons.check_circle,
                                    color: Color(0xFFB71C1C),
                                    size: 22,
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
