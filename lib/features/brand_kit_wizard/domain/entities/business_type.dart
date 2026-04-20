class BusinessType {
  final String id;
  final String name;
  final String icon;

  const BusinessType({
    required this.id,
    required this.name,
    required this.icon,
  });

  static const List<BusinessType> predefined = [
    BusinessType(id: 'restaurant', name: 'Restaurant', icon: 'restaurant'),
    BusinessType(id: 'tech_startup', name: 'Tech Startup', icon: 'computer'),
    BusinessType(id: 'consulting', name: 'Consulting', icon: 'business'),
    BusinessType(id: 'retail', name: 'Retail', icon: 'store'),
    BusinessType(id: 'healthcare', name: 'Healthcare', icon: 'local_hospital'),
    BusinessType(id: 'education', name: 'Education', icon: 'school'),
    BusinessType(id: 'finance', name: 'Finance', icon: 'account_balance'),
    BusinessType(id: 'entertainment', name: 'Entertainment', icon: 'movie'),
    BusinessType(id: 'travel', name: 'Travel', icon: 'flight'),
    BusinessType(id: 'food', name: 'Food & Beverage', icon: 'fastfood'),
    BusinessType(id: 'fashion', name: 'Fashion', icon: 'checkroom'),
    BusinessType(id: 'real_estate', name: 'Real Estate', icon: 'home'),
    BusinessType(id: 'fitness', name: 'Fitness', icon: 'fitness_center'),
    BusinessType(id: 'beauty', name: 'Beauty & Spa', icon: 'spa'),
    BusinessType(id: 'other', name: 'Other', icon: 'more_horiz'),
  ];
}
