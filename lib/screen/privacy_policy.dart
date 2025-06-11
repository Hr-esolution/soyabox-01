import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Politique de Confidentialité'),
        backgroundColor: Colors.redAccent, // Couleur de l'entête
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Dernière mise à jour : 25 Janvier 2025",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey),
            ),
            const SizedBox(height: 20),

            _buildSectionTitle("1. Introduction"),
            _buildSectionContent(
                "Bienvenue sur l'application Soyabox, votre plateforme de commande de sushi à Casablanca et Mohammedia. "
                "Cette politique de confidentialité explique comment nous collectons, utilisons et protégeons vos informations personnelles lorsque vous utilisez notre application."),

            _buildSectionTitle("2. Informations Collectées"),
            _buildSectionContent("Nous collectons les informations suivantes :"),
            _buildBulletPoint("📱 Numéro de téléphone : Pour créer et gérer votre compte."),
            _buildBulletPoint("🔑 Mot de passe : Pour sécuriser votre compte."),
            _buildBulletPoint("🏠 Adresse : Pour livrer vos commandes."),
            _buildBulletPoint("📦 Historique des commandes : Pour améliorer votre expérience utilisateur."),

            _buildSectionTitle("3. Utilisation des Informations"),
            _buildSectionContent("Vos informations sont utilisées pour :"),
            _buildBulletPoint("👤 Créer et gérer votre compte."),
            _buildBulletPoint("🚚 Traiter et livrer vos commandes."),
            _buildBulletPoint("🔥 Vous informer des promotions et offres spéciales."),
            _buildBulletPoint("📊 Améliorer nos services et personnaliser votre expérience."),

            _buildSectionTitle("4. Partage des Informations"),
            _buildSectionContent("Nous ne partageons pas vos informations personnelles avec des tiers, sauf pour :"),
            _buildBulletPoint("📦 Les services de livraison pour exécuter vos commandes."),
            _buildBulletPoint("⚖️ Les obligations légales (si requis par la loi)."),

            _buildSectionTitle("5. Sécurité des Données"),
            _buildSectionContent(
                "Nous utilisons des mesures de sécurité techniques et organisationnelles pour protéger vos informations contre tout accès non autorisé ou toute perte."),

            _buildSectionTitle("6. Vos Droits"),
            _buildSectionContent("Vous avez le droit de :"),
            _buildBulletPoint("🔍 Accéder à vos informations personnelles."),
            _buildBulletPoint("🗑️ Demander la suppression de vos données."),
            _buildBulletPoint("🚫 Refuser l'utilisation de vos données à des fins marketing."),

            _buildSectionTitle("7. Contact"),
            _buildSectionContent("Pour toute question concernant cette politique, contactez-nous à :"),
            _buildBulletPoint("📧 Email : contact@soyabox.ma"),
            _buildBulletPoint("📞 Téléphone : +212-5208325"),

            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                ),
                child: const Text("Fermer", style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 10),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
      ),
    );
  }

  Widget _buildSectionContent(String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        content,
        style: const TextStyle(fontSize: 16, color: Colors.black87),
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, bottom: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("• ", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 16))),
        ],
      ),
    );
  }
}
