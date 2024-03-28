
import 'package:client/utils/svg_utils.dart';


const _danger = '_danger';
const _custom = '_custom';

enum Illustration implements ISvg {

  paymentWithCardTop("payment-with-card-3--top", _custom),
  paymentWithCardBottom("payment-with-card-3--bottom", _custom),
  norwayMap("norway", _custom),

  anonymous("hack-1"),
  centralized("data-cloud-3"),
  secured("security-1"),
  collaborative("feasibility-meeting"),
  automate("personal-assistant-2"),
  crossPlatform("manager-desk-2"),
  customizable("coding-a-website-2"),

  howItWorksStep1("downloading-1"),
  howItWorksStep2("e-wallet-transaction"),
  howItWorksStep3("successful-business-4"),

  ourTeam("about-our-team-1"),

  chasingMoney("chasing-money-3"),
  growingMoney("money-growing-on-trees-4"),

  hiring("hiring-7"),
  privacyPolicy("logged-out-2"),

  timeInForWork("imac-workspace-4"),
  emptyResult("curious-dog"),
  dataLoading("app-working-2"),

  successMale("employee-checklist-1"),
  successFemale("employee-checklist-4"),

  integrations("cloud-sync-14"),

  unexpectedError("program-error-1", _danger),
  underConstruction("app-building-2"),

  bank("bank-building-2"),
  cash("bank-notes"),
  crypto("cryptocurrencies"),
  securities("metal-briefcase"),

  debit("bank-notes"),
  credit("cryptocurrencies"),
  saving("metal-briefcase"),

  manualAccount("invoice-calculating"),
  automatedAccount("money-app-transfer")

  ;

  @override
  final String asset;

  const Illustration(String asset, [String variant = '_primary']) : asset = asset + variant;
}