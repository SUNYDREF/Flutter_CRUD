class Blog {
  final String title;
  final String slug;
  final String category;
  final String image;
  final String description;

  const Blog({
    required this.title,
    required this.slug,
    required this.category,
    required this.image,
    required this.description,
  });

  factory Blog.fromJson(Map<String, dynamic> json) {
    return Blog(
      title: json['title'],
      slug: json['slug'],
      category: json['category'],
      image: json['image'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'slug': slug,
      'category': category,
      'image': image,
      'description': description,
    };
  }
}
