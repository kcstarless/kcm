# KCM - Kingston Central Market 🏪

A modern, full-stack e-commerce marketplace application built with Ruby on Rails and Vite that provides comprehensive shopping, cart management, and payment capabilities. The platform integrates with Stripe for secure payment processing and features a responsive design optimized for market vendors and customers.

## 🚀 Features

### 🛍️ **Shopping & Product Discovery**
- **Real-time Product Search**: Dynamic product filtering and search functionality
- **Multi-vendor Marketplace**: Support for multiple traders and shop owners
- **Smart Category Navigation**: Intuitive product categorization and browsing
- **Product Management**: Comprehensive product listings with images and descriptions
- **Interactive Shopping Cart**: Real-time cart updates with quantity management

### 🛒 **Advanced Cart & Ordering**
- **Dynamic Cart Management**: Add, remove, and modify cart items in real-time
- **Order Processing**: Multi-step checkout process with validation
- **Delivery Options**: Support for both pickup and delivery methods
- **Time Slot Booking**: Schedule delivery times and pickup slots
- **Order Confirmation**: Detailed order summaries and confirmation emails

### 💳 **Payment & Checkout System**
- **Stripe Integration**: Secure payment processing with multiple payment methods
- **Guest & User Checkout**: Support for both authenticated and guest purchases
- **Order Tracking**: Real-time order status and confirmation system
- **Payment Validation**: Secure payment processing with error handling
- **Receipt Generation**: Digital receipts and order confirmations

### 👤 **User Management & Authentication**
- **User Registration**: Secure user account creation and management
- **Session Management**: JWT-based authentication system
- **User Dashboard**: Personal shopping history and order management
- **Admin Panel**: Vendor and product management capabilities
- **Role-based Access**: Different permissions for customers, vendors, and admins

### 🏪 **Vendor & Shop Management**
- **Multi-shop Support**: Individual vendor storefronts and management
- **Product Upload**: Easy product addition with image management
- **Order Management**: Vendor order processing and fulfillment
- **Shop Customization**: Personalized shop pages and branding
- **Inventory Tracking**: Stock management and availability updates

## 🛠️ Technology Stack

### **Backend**
- **Framework**: Ruby on Rails 7.x
- **Database**: PostgreSQL with Active Storage
- **Authentication**: Custom authentication with JWT tokens
- **Server**: Puma with background job processing
- **File Storage**: Active Storage for image management
- **Email**: Action Mailer with order notifications

### **Frontend**
- **Build Tool**: Vite with modern JavaScript bundling
- **Styling**: SCSS with custom design system
- **JavaScript**: Stimulus controllers for interactivity
- **UI Components**: Custom component library with animations
- **Forms**: Turbo-powered forms with real-time validation
- **Responsive Design**: Mobile-first responsive layout

### **External APIs & Services**
- **Payments**: Stripe Payment Intents and webhooks
- **Email Service**: SMTP for transactional emails
- **Image Processing**: Active Storage with image variants
- **Background Jobs**: Rails Active Job for async processing

### **Development & Deployment**
- **Containerization**: Docker with multi-stage builds
- **Asset Pipeline**: Vite integration with Rails
- **Testing**: Rails testing framework with system tests
- **Environment**: Ruby 3.x, Node.js for asset compilation

## 🏗️ Architecture

```
kcm/
├── app/
│   ├── controllers/              # Application controllers
│   │   ├── application_controller.rb    # Base controller
│   │   ├── cart_items_controller.rb     # Cart management
│   │   ├── carts_controller.rb          # Shopping cart logic
│   │   ├── checkouts_controller.rb      # Checkout process
│   │   ├── delivery_controller.rb       # Delivery management
│   │   ├── orders_controller.rb         # Order processing
│   │   ├── shops_controller.rb          # Shop management
│   │   └── stripe_webhooks_controller.rb # Payment webhooks
│   ├── models/                   # Data models
│   │   ├── admin.rb             # Admin user model
│   │   ├── cart.rb              # Shopping cart model
│   │   ├── cart_item.rb         # Cart item model
│   │   ├── order.rb             # Order model
│   │   ├── product.rb           # Product model
│   │   ├── shop.rb              # Shop/vendor model
│   │   └── user.rb              # User authentication
│   ├── views/                   # ERB templates
│   │   ├── layouts/             # Application layouts
│   │   ├── shared/              # Shared partials
│   │   ├── orders/              # Order views
│   │   └── shops/               # Shop views
│   ├── frontend/                # Frontend assets
│   │   ├── controllers/         # Stimulus controllers
│   │   ├── entrypoints/         # Vite entry points
│   │   └── styles/              # SCSS stylesheets
│   └── assets/                  # Static assets
│       ├── stylesheets/         # Application styles
│       ├── images/              # Image assets
│       └── videos/              # Video assets
├── config/                      # Rails configuration
│   ├── routes.rb               # Application routing
│   ├── database.yml            # Database configuration
│   ├── vite.json               # Vite configuration
│   └── initializers/           # App initializers
├── db/                         # Database files
│   ├── migrate/                # Database migrations
│   ├── schema.rb               # Database schema
│   └── seeds.rb                # Seed data
└── storage/                    # File storage
```

## 🚦 Getting Started

### Prerequisites
- **Ruby**: 3.2+
- **Node.js**: 18+
- **PostgreSQL**: 12+
- **Stripe Account**: For payment processing

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd kcm
   ```

2. **Install Dependencies**
   ```bash
   # Install Ruby gems
   bundle install
   
   # Install Node.js packages
   npm install
   ```

3. **Database Setup**
   ```bash
   rails db:create
   rails db:migrate
   rails db:seed
   ```

4. **Environment Configuration**
   ```bash
   # Create master key file
   rails credentials:edit
   
   # Add required credentials:
   stripe:
     secret_key: your_stripe_secret_key
     publishable_key: your_stripe_publishable_key
   ```

5. **Start Development Server**
   ```bash
   # Start the development server with asset compilation
   bin/dev
   
   # Or run separately:
   rails server          # Rails server (port 3000)
   npm run build --watch  # Vite asset compilation
   ```

6. **Access the Application**
   - Application: [http://localhost:3000](http://localhost:3000)
   - Admin panel: Available after user authentication

### Available Scripts

```bash
# Development
bin/dev                   # Start development server with assets
rails server              # Start Rails server only
rails console             # Rails console for debugging
rails test                # Run test suite

# Asset Management
npm run build             # Build assets for production
npm run build:css         # Build CSS only
vite build                # Build with Vite

# Database
rails db:migrate          # Run database migrations
rails db:seed             # Seed database with sample data
rails db:reset            # Reset and reseed database
```

## 📊 Core Functionality

### Shopping Cart System
The application features a sophisticated shopping cart system:

- **Real-time Updates**: Cart changes reflect immediately across the application
- **Persistent Storage**: Cart contents persist between user sessions
- **Quantity Management**: Easy increment/decrement with validation
- **Price Calculation**: Automatic subtotal and total calculations
- **Stock Validation**: Prevents over-ordering with real-time stock checks

### Order Processing
- **Multi-step Checkout**: Guided checkout process with validation
- **Delivery Scheduling**: Time slot selection for delivery and pickup
- **Address Management**: Delivery address collection and validation
- **Payment Processing**: Secure Stripe integration with webhook handling
- **Order Confirmation**: Email notifications and order tracking

### Vendor Management
- **Shop Creation**: Vendors can create and customize their storefronts
- **Product Management**: Easy product addition with image upload
- **Order Fulfillment**: Vendor order management and processing
- **Analytics**: Basic sales and order analytics for vendors

## 🎨 Design Features

### User Interface
- **Responsive Design**: Mobile-first approach with desktop optimization
- **Modern Aesthetics**: Clean, market-inspired design with custom styling
- **Interactive Elements**: Smooth animations and hover effects
- **Accessibility**: Keyboard navigation and screen reader support
- **Fast Loading**: Optimized asset delivery with Vite

### Shopping Experience
- **Product Gallery**: High-quality product images with zoom functionality
- **Filter System**: Advanced product filtering and search
- **Quick Add**: One-click add to cart functionality
- **Visual Feedback**: Real-time loading states and success indicators
- **Error Handling**: Graceful error handling with user-friendly messages

## 🔧 Configuration

### Environment Variables

**Rails Credentials**
```bash
# Edit encrypted credentials
rails credentials:edit

# Add required keys:
stripe:
  secret_key: sk_test_...
  publishable_key: pk_test_...
database:
  password: your_db_password
secret_key_base: your_secret_key
```

### Stripe Configuration
```ruby
# config/initializers/stripe.rb
Stripe.api_key = Rails.application.credentials.stripe[:secret_key]
```

### Customization Options
- **Market Branding**: Customize colors, fonts, and imagery
- **Product Categories**: Modify product categorization system
- **Delivery Options**: Configure delivery zones and time slots
- **Payment Methods**: Enable/disable specific payment options
- **Email Templates**: Customize transactional email templates

## 📈 Performance Optimizations

- **Asset Optimization**: Vite-powered asset bundling and minification
- **Image Processing**: Active Storage with optimized image variants
- **Caching Strategy**: Fragment caching for product listings
- **Database Optimization**: Efficient queries with eager loading
- **Background Processing**: Async job processing for heavy operations

## 🧪 Testing

### Test Suite
```bash
rails test                    # Run all tests
rails test:models            # Test models only
rails test:controllers       # Test controllers only
rails test:system           # Run system tests
```

**Test Coverage Includes:**
- **Model Tests**: User authentication, cart logic, order processing
- **Controller Tests**: API endpoints and form submissions
- **Integration Tests**: Complete user workflows
- **System Tests**: End-to-end user experience testing

## 🚀 Deployment

### Production Setup
```bash
# Precompile assets
rails assets:precompile

# Run database migrations
rails db:migrate RAILS_ENV=production

# Start production server
rails server -e production
```

### Docker Deployment
```bash
# Build Docker image
docker build -t kcm .

# Run container
docker run -p 3000:3000 -e RAILS_ENV=production kcm
```

## 🐛 Troubleshooting

### Common Issues

**Asset Compilation Issues:**
```bash
# Clear asset cache
rm -rf tmp/cache/assets/
npm run build

# Restart server
bin/dev
```

**Database Connection Errors:**
```bash
# Check database status
rails db:version

# Reset database
rails db:reset
```

**Stripe Integration Issues:**
- Verify webhook endpoints are configured correctly
- Check Stripe dashboard for failed payments
- Ensure test vs production keys are properly set

**File Upload Problems:**
```bash
# Check Active Storage configuration
rails active_storage:install
rails db:migrate
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/amazing-feature`
3. Commit changes: `git commit -m 'Add amazing feature'`
4. Push to branch: `git push origin feature/amazing-feature`
5. Submit a pull request

### Development Guidelines
- Follow Rails conventions and best practices
- Write tests for new features
- Use semantic commit messages
- Update documentation as needed
- Ensure responsive design compatibility

## 📝 Project Structure

### Key Components

**Authentication System:**
- Custom user authentication with session management
- Role-based access control (customers, vendors, admins)
- Secure password handling and validation

**Shopping Cart:**
- Persistent cart storage across sessions
- Real-time price calculations
- Stock validation and availability checking

**Order Management:**
- Complete order lifecycle from cart to confirmation
- Delivery scheduling and address management
- Payment processing with Stripe integration

**Vendor System:**
- Multi-vendor marketplace capabilities
- Individual shop management and customization
- Product upload and inventory management

## 🏆 Key Achievements

- ✅ **Full-Stack Rails Application**: Modern Rails 7 with Vite integration
- ✅ **Real-time Shopping Cart**: Dynamic cart management with persistent storage
- ✅ **Secure Payment Processing**: PCI-compliant Stripe integration
- ✅ **Multi-vendor Support**: Comprehensive marketplace functionality
- ✅ **Responsive Design**: Mobile-first responsive interface
- ✅ **Modern Asset Pipeline**: Vite-powered frontend development
- ✅ **Order Management**: Complete order lifecycle with notifications
- ✅ **Image Management**: Active Storage integration for product photos

## 📞 Development Notes

### Current Features
- Complete user registration and authentication system
- Dynamic shopping cart with real-time updates
- Multi-step checkout process with delivery options
- Stripe payment integration with webhook handling
- Vendor shop management and product upload
- Order confirmation and email notifications
- Responsive design optimized for mobile and desktop

### Planned Enhancements
- Advanced search and filtering capabilities
- Vendor analytics and reporting dashboard
- Customer review and rating system
- Inventory management automation
- Advanced delivery tracking
- Multi-language support

---

**Built with ❤️ using Ruby on Rails, Vite, and modern web technologies for the Kingston Central Market community**
