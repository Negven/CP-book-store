



// NB! Don't change icon position == glyph
enum FontIcon {

  translate,
  themeMode,

  menu,

  playStore,
  appleIcon,

  add,
  subtract,

  modalClose,

  googleIcon,

  devUser,
  devUserWithKey,

  caretDown,
  caretRight,

  circleEmpty,
  circleDot,

  recentlyUsed,

  circleCheck,
  circleInfo,
  triangleExclamation,
  circleExclamation,

  fileShare,
  fileCopy,
  fileDownload,
  fileSearch,

  paste,

  addWallet,

  chartCombo,
  chartPie,
  files,
  cogs,
  conversation,
  creditCards,
  home,
  users,
  merchants,
  transactions,
  helpQuestion,
  tags,
  walletSetting,

  search,
  browser,

  navigationBack,

  addBold,
  addMoreFilled,
  addMoreOutlined,
  addCircleOutlined,

  arrowLeft,
  arrowRight,
  ;

  const FontIcon();

  int get codePoint => 0xE800 + index;

}

