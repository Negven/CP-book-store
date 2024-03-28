

abstract class InfNB {
  static get translations => <String,String>{
    'termsOfService_title': 'Vilkår for bruk',
    'termsOfService_date': 'Gyldig fra: 01.10.2023',
    'termsOfService': termsOfService,
    'privacyPolicy_title': 'Personvernserklæring',
    'privacyPolicy_date': 'Gyldig fra: 01.09.2023',
    'privacyPolicy': privacyPolicy,
    'infPageSection_features': 'Funksjoner',
    'infPageSection_howItWorks': 'Slik fungerer det',
    'infPageSection_whoWeAre': 'Om oss',
    'infPageSection_pricing': 'Priser',
    'addWalletModal_signIn': 'Logg inn',
    'addWalletModal_logIn': 'Logg inn',
    'or_download_from': 'Eller last ned vår applikasjon fra',
    'infPage_home_grow': 'Grow.',
    'infPage_home_plan': 'Plan.',
    'infPage_home_track': 'Track.',
    'infPage_features_anonymous': 'Anonym',
    'infPage_features_anonymousDetails': 'Sensitive og personlige data blir automatisk kryptert på en måte som gjør at bare du har tilgang til dem.',
    'infPage_features_centralized': 'Sentralisert',
    'infPage_features_centralizedDetails': 'Alle data lagres på våre servere, så du trenger ikke å administrere, synkronisere og sikkerhetskopiere informasjon selv.',
    'infPage_features_secured': 'Sikret',
    'infPage_features_securedDetails': 'Å lagre dataene dine hos oss er sikrere enn i noen annen bank. Det er rett og slett kvantesikkert.',
    'infPage_features_collaborative': 'Samarbeidende',
    'infPage_features_collaborativeDetails': 'Vi støtter deling av data mellom flere brukere på den mest effektive måten for å føre felles budsjett.',
    'infPage_features_automated': 'Automatisert',
    'infPage_features_automatedDetails': 'Målet vårt er å gjøre budsjettsporing på den mest automatiserte måten med nesten null intervensjon.',
    'infPage_features_crossPlatform': 'Kryssplattform',
    'infPage_features_crossPlatformDetails': 'Du kan få tilgang til dataene dine med samme funksjonalitet fra nettlesere, Android- og iOS-enheter.',
    'infPage_features_customizable': 'Tilpassbar',
    'infPage_features_customizableDetails': 'Vi er alltid åpne for å implementere eller forbedre funksjoner på forespørsel fra våre kunder.',
    'infPage_howItWorks_step1': 'Steg 1.',
    'infPage_howItWorks_step1Details': 'Last ned appen vår eller logg på her.',
    'infPage_howItWorks_step2': 'Steg 2.',
    'infPage_howItWorks_step2Details': 'Koble til bankene og kontoene dine.',
    'infPage_howItWorks_step3': 'Steg 3.',
    'infPage_howItWorks_step3Details': 'Se ditt budsjettet vokse.',
    'infPage_pricing_premium': 'Premium',
    'infPage_pricing_premiumPrice': '\$ 9 / bruker / måned',
    'infPage_pricing_starter': 'Starter',
    'infPage_pricing_starterPrice': '\$ 0 / første 3 måneder',
    'infPage_pricing_starterFeature1': 'Integrasjon med banker',
    'infPage_pricing_starterFeature2': 'Anonym datalagring',
    'infPage_pricing_starterFeature3': 'Kvantesikker kryptering',
    'infPage_pricing_starterFeature4': 'Smart kategorisering',
    'infPage_pricing_starterFeature5': 'Avansert analyse',
    'infPage_pricing_starterFeature6': 'Tilpassbare varsler',
    'infPage_pricing_starterFeature7': 'Flerbrukerbudsjettering',
    'infPage_pricing_premiumFeature1': 'Filvedlegg',
    'infPage_pricing_premiumFeature2': 'Direkt støtte',
    'infPage_pricing_stopAction': 'Slutt å jage penger!',
    'infPage_pricing_growAction': 'Begynn å skaffe penger,',
    'infPage_pricing_growAction_now': 'NÅ!',
    'infPage_whoWeAre_team': 'Team',
    'infPage_whoWeAre_teamDetails': 'Vi er en norsk startup som kobler sammen erfarne personer innen fintech-applikasjonsutvikling.',
    'infPage_whoWeAre_legal': 'Juridisk informasjon',
    'infPage_whoWeAre_orgNo': 'Org.nr',
    'infPage_whoWeAre_showTeam': 'Vis teammedlemmer',
    'infPage_whoWeAre_showCompany': 'Vis juridisk informasjon',
    'infPage_whoWeAre_techSkills': 'Ferdigheter',
    'infPage_whoWeAre_experience': 'Erfaring',
    'infPage_whoWeAre_experience_years': 'år',
    'infPage_whoWeAre_hobby': 'Hobby',
    'andrey_title': 'CEO / Løsningsarkitekt',
    'andrey_techSkills': 'Flutter, ML/AI, UI/UX',
    'andrey_hobby': 'Kunst & sjakk',
    'igor_title': 'CTO / Prosjekteier',
    'igor_techSkills': 'Spring, Cloud, CI/CD',
    'igor_hobby': 'Historie og fotball',
    'artur_title': 'Fullstack-utvikler',
    'artur_techSkills': 'Java, Postgres, Docker',
    'artur_hobby': 'Fotografi',
    'hiring_name': 'Vi ansetter!',
    'hiring_title': 'Programvareutviklere med',
    'hiring_techSkills': 'Dart, Java, SQL',
    'hiring_hobby': 'Alle slags',
  };
}


const privacyPolicy = """

###### Juridisk informasjon

Denne **personvernserklæringen** _("Erklæring")_ beskriver praksisen til **Spendly AS** _("vi," "oss," eller "vårt")_ angående innsamling, bruk og beskyttelse av personlig informasjon når du bruker vår personlige økonomi sporingsapplikasjon _("Applikasjon")_. Vi forplikter oss til å beskytte personvernet og sikkerheten til dine data. Ved å bruke vår Applikasjon samtykker du i praksisene som beskrives i denne Erklæringen.

#### 1. Anonym lagring av data
**1.1 Dataanonymitet:** Vi forstår viktigheten av å beskytte din personlige informasjon. Vår Applikasjon lagrer all brukerdata på en fullstendig anonym måte. Dette betyr at din personlige data er frakoblet all identifiserbar informasjon, som ditt navn, e-postadresse eller fysiske adresse.

**1.2 Brukerdata:** Når du bruker vår Applikasjon, kan vi samle og lagre visse data, inkludert detaljer om økonomiske transaksjoner, budsjettopplysninger og annen økonomisk informasjon. Disse dataene er fjernet fra personlige identifikatorer og lagret på en måte som forhindrer kobling til deg som enkeltperson.

#### 2. Beskyttelse av personlig tekstinformasjon
**2.1 Masterpassord:** Vi tar sikkerheten til din personlige tekstinformasjon på alvor. Ingen, inkludert vårt team eller tredjeparter, vil ha tilgang til brukerens personlige tekstinformasjon uten det masterpassordet som er oppgitt av brukeren. Dette masterpassordet brukes til å kryptere og dekryptere dine sensitive data.

**2.2 Kryptering:** Din personlige tekstinformasjon lagres ved hjelp av sterke krypteringsmetoder for å sikre at den forblir konfidensiell og sikker. Selv om vi skulle få tilgang til de krypterte dataene, ville vi ikke være i stand til å dechiffrere dem uten ditt masterpassord.

#### 3. Pålitelige og betrodde integrasjonsleverandører
**3.1 Integrasjonsleverandører:** Vi kan integrere med ulike tredjepartstjenester og leverandører for å forbedre funksjonaliteten til vår Applikasjon. Disse integrasjonene velges nøye for å sikre høyeste nivå av pålitelighet og pålitelighet.

**3.2 Deling av data:** Når vi integrerer med tredjepartsleverandører, deler vi bare data som er nødvendige for å gi deg de tiltenkte tjenestene eller funksjonene. Vi deler ikke personlig identifiserbar informasjon uten ditt uttrykkelige samtykke.

**3.3 Personvernerklæringer:** Vi oppfordrer deg til å gjennomgå personvernerklæringene til eventuelle tredjepartsintegreringsleverandører vi bruker, da de kan ha sine egne praksiser for innsamling og bruk av data. Vi er ikke ansvarlige for personvernspraksisene til disse tredjepartene.

#### 4. Dataoppbevaring
Vi oppbevarer dine anonymiserte økonomiske data så lenge det er nødvendig for å gi deg våre tjenester og for å overholde juridiske forpliktelser. Hvis du velger å slette kontoen din, vil vi slette dine data sikkert fra våre systemer.

#### 5. Dine valg og rettigheter
Du har visse rettigheter angående dine personlige data, inkludert retten til å få tilgang til, rette eller slette dataene dine. Du kan administrere dine datavalg innenfor Applikasjonen. Hvis du har spørsmål eller forespørsler angående dataene dine, vennligst kontakt oss på support@spendly.eu.

#### 6. Endringer i denne Erklæringen
Vi kan oppdatere denne personvernserklæringen fra tid til annen for å gjenspeile endringer i våre praksiser eller av juridiske eller regulatoriske årsaker. Eventuelle endringer vil bli lagt ut på denne siden, og den effektive datoen vil bli oppdatert tilsvarende. Vi oppfordrer deg til å gjennomgå denne Erklæringen jevnlig.

#### 7. Kontakt oss
Hvis du har spørsmål eller bekymringer angående denne personvernserklæringen eller våre datapraksiser, vennligst kontakt oss på:

- Spendly AS
- St. Olavs gate 8A, 0165 Oslo
- support@spendly.eu

Ved å bruke vår Applikasjon erkjenner du at du har lest og forstått denne personvernserklæringen og samtykker til vilkårene og betingelsene.

""";

const termsOfService = """

###### Juridisk informasjon

Disse Vilkårene for bruk _("Vilkår")_ styrer din bruk av Spendly-nettstedet som ligger på [www.spendly.eu](https://www.spendly.eu) _("Nettstedet")_ og Spendly-mobilapplikasjonene for Android og iOS _(samlet referert til som "Applikasjon")_. Ved å få tilgang til eller bruke Nettstedet eller Applikasjonen, samtykker du i å overholde og være bundet av disse Vilkårene. Hvis du ikke godtar disse Vilkårene, vennligst ikke bruk Nettstedet eller Applikasjonen.

#### 1. Brukerkontoer

**1.1 Brukerkontoer:** For å få tilgang til visse funksjoner på Nettstedet og Applikasjonen, kan det være nødvendig å opprette en brukerkonto _("Konto")_. Du samtykker i å oppgi nøyaktig og fullstendig informasjon under registreringsprosessen og holde Kontoinformasjonen din oppdatert.

**1.2 Kontosikkerhet:** Du er ansvarlig for å opprettholde sikkerheten til din Konto og for alle aktiviteter som skjer under din Konto. Du må ikke dele påloggingsopplysningene dine med noen andre. Hvis du mistenker uautorisert tilgang til din Konto, må du varsle oss umiddelbart.

#### 2. Brukergenerert innhold

**2.1 Numerisk Innhold:** Brukere av Spendly kan ha muligheten til å laste opp, sende inn, eller dele numerisk innhold, som økonomiske data og transaksjoner _("Numerisk Innhold")_. Du beholder eierskapet til ditt Numeriske Innhold, men ved å laste det opp eller sende det inn, gir du Spendly en global, ikke-eksklusiv, royaltyfri lisens til å bruke, reprodusere, modifisere, og distribuere ditt Numeriske Innhold som nødvendig for å levere tjenestene som tilbys av Spendly.

**2.2 Tekstlig Innhold:** Brukere av Spendly kan også ha muligheten til å laste opp, sende inn, eller dele tekstlig innhold _("Tekstlig Innhold")_. Spendly vil behandle Tekstlig Innhold annerledes ved å kryptere det fullstendig og behandle det som en sikker skylagringstjeneste for anonymiserte data. Spendly vil ikke få tilgang til, se, eller behandle Tekstlig Innhold, og det vil forbli fullstendig kryptert til enhver tid. Spendly vil ikke bruke, reprodusere, modifisere, eller distribuere Tekstlig Innhold, bortsett fra for formålet med lagring og henting som forespurt av brukeren.

**2.3 Retningslinjer for innhold:** Du samtykker i å ikke laste opp, sende inn, eller dele Numerisk Innhold eller Tekstlig Innhold som bryter med gjeldende lover eller forskrifter eller krenker andres rettigheter, inkludert immaterielle rettigheter, personvernrettigheter, eller andre rettigheter.

#### 3. Abonnementsplaner

**3.1 Abonnementsplaner:** Spendly tilbyr abonnementsplaner med ulike funksjoner og priser _("Abonnementsplaner")_. Ved å kjøpe en Abonnementsplan samtykker du i vilkårene og prisene som er knyttet til den planen. Abonnementsavgifter blir belastet ditt valgte betalingsmiddel.

**3.2 Betaling og fakturering:** Betalinger for Abonnementsplaner behandles av tredjeparts betalingsbehandlere. Ved å oppgi betalingsinformasjon gir du Spendly tillatelse til å belaste de aktuelle avgiftene. Du er ansvarlig for å holde betalingsinformasjonen din nøyaktig og oppdatert.

#### 4. Personvernregler

Din bruk av Nettstedet og Applikasjonen er underlagt vår Personvernregler, som du finner på [www.spendly.eu/inf/legal/privacy-policy](https://www.spendly.eu/inf/legal/privacy-policy). Personvernreglene forklarer hvordan vi samler, bruker, og beskytter din personlige informasjon.

#### 5. Avslutning

**5.1 Avslutning av bruker:** Du kan avslutte din Konto og slutte å bruke Nettstedet og Applikasjonen når som helst.

**5.2 Avslutning av Spendly:** Vi forbeholder oss retten til å suspendere eller avslutte din Konto og tilgang til Nettstedet og Applikasjonen etter vårt eget skjønn, med eller uten grunn, og uten varsel.

#### 6. Endringer i Vilkårene

Spendly kan oppdatere disse Vilkårene fra tid til annen. Eventuelle endringer vil bli publisert på Nettstedet og Applikasjonen, og "Effektiv dato" øverst i disse Vilkårene vil bli oppdatert tilsvarende. Det er ditt ansvar å jevnlig gjennomgå disse Vilkårene for endringer.

#### 7. Kontakt oss

Hvis du har spørsmål eller bekymringer angående disse Vilkårene for bruk eller noen aspekt av Spendly, vennligst kontakt oss på:

- Spendly AS
- St. Olavs gate 8A, 0165 Oslo
- support@spendly.eu

Ved å bruke Spendly Nettstedet og Applikasjonen, erkjenner du at du har lest og forstått disse Vilkårene og samtykker til å være bundet av dem.

""";