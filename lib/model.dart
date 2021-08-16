class Restaurant {
  Restaurant({
    this.id,
    this.name,
    this.description,
    this.city,
    this.address,
    this.pictureId,
    this.categories,
    this.menus,
    this.rating,
    this.customerReviews,
  });

  String? id;
  String? name;
  String? description;
  String? city;
  String? address;
  String? pictureId;
  List<Detail>? categories;
  Menus? menus;
  double? rating;
  List<CustomerReview>? customerReviews;

  factory Restaurant.fromJson(Map<String, dynamic> json) => Restaurant(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        city: json["city"],
        address: json["address"],
        pictureId: json["pictureId"],
        categories:
            json.containsKey("categories") ? List<Detail>.from(json["categories"].map((x) => Detail.fromJson(x))) : [],
        menus: json.containsKey("menus") ? Menus.fromJson(json["menus"]) : null,
        rating: json["rating"].toDouble(),
        customerReviews: json.containsKey("customerReviews")
            ? List<CustomerReview>.from(json["customerReviews"].map((x) => CustomerReview.fromJson(x)))
            : [],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "city": city,
        "address": address,
        "pictureId": pictureId,
        "categories": List<dynamic>.from(categories!.map((x) => x.toJson())),
        "menus": menus?.toJson() ?? {},
        "rating": rating,
        "customerReviews": List<dynamic>.from(customerReviews!.map((x) => x.toJson())),
      };
}

class Detail {
  Detail({
    this.name,
  });

  String? name;

  factory Detail.fromJson(Map<String, dynamic> json) => Detail(
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
      };
}

class CustomerReview {
  CustomerReview({
    this.name,
    this.review,
    this.date,
  });

  String? name;
  String? review;
  String? date;

  factory CustomerReview.fromJson(Map<String, dynamic> json) => CustomerReview(
        name: json["name"],
        review: json["review"],
        date: json["date"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "review": review,
        "date": date,
      };
}

class Menus {
  Menus({
    this.foods,
    this.drinks,
  });

  List<Detail>? foods;
  List<Detail>? drinks;

  factory Menus.fromJson(Map<String, dynamic> json) => Menus(
        foods: List<Detail>.from(json["foods"].map((x) => Detail.fromJson(x))),
        drinks: List<Detail>.from(json["drinks"].map((x) => Detail.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "foods": List<dynamic>.from(foods!.map((x) => x.toJson())),
        "drinks": List<dynamic>.from(drinks!.map((x) => x.toJson())),
      };
}
