import 'package:flutter/material.dart';

import '../models/fi_models.dart';

abstract final class FiCatalog {
  static const domainId = 'feminine-intelligence';

  static const assessmentQuestions = <FiAssessmentQuestion>[
    FiAssessmentQuestion(
      id: 'assessment-01',
      prompt: 'شخص قريب طلب منك خدمة وأنتِ مرهقة جدًا. شو الأقرب لتصرفك الحقيقي؟',
      options: [
        FiAssessmentOption(id: 'a', label: 'بوافق حتى ما يزعل.', weights: FiWeights(peoplePleasing: 3)),
        FiAssessmentOption(id: 'b', label: 'برفض بسرعة وبنهي الموضوع.', weights: FiWeights(controlRigidity: 2)),
        FiAssessmentOption(id: 'c', label: 'بشوف وقتي وطاقتي وبقرر.', weights: FiWeights(practicalIntelligence: 2)),
        FiAssessmentOption(id: 'd', label: 'بطلب وقت، وبشوف أهمية الطلب وحدودي.', weights: FiWeights(relationalWisdom: 2, practicalIntelligence: 1)),
      ],
    ),
    FiAssessmentQuestion(
      id: 'assessment-02',
      prompt: 'شخص مهم بحياتك خالفك بقرار إنتِ مقتنعة فيه. شو بصير غالبًا؟',
      options: [
        FiAssessmentOption(id: 'a', label: 'بتراجع حتى ما نخسر بعض.', weights: FiWeights(peoplePleasing: 3)),
        FiAssessmentOption(id: 'b', label: 'بصرّ على رأيي لأنه واضح بالنسبة إلي.', weights: FiWeights(controlRigidity: 3)),
        FiAssessmentOption(id: 'c', label: 'بشرح أسبابي وبجمع معلومات أكتر.', weights: FiWeights(practicalIntelligence: 2)),
        FiAssessmentOption(id: 'd', label: 'بفهم اعتراضه وببحث عن نتيجة تحمي حقي والعلاقة.', weights: FiWeights(relationalWisdom: 3)),
      ],
    ),
    FiAssessmentQuestion(
      id: 'assessment-03',
      prompt: 'حدا زعلان منك وإنتِ مو مقتنعة إنك غلطانة.',
      options: [
        FiAssessmentOption(id: 'a', label: 'بحاول أرضيه فورًا.', weights: FiWeights(peoplePleasing: 3)),
        FiAssessmentOption(id: 'b', label: 'خليه يزعل، ما بدي افتح الموضوع.', weights: FiWeights(controlRigidity: 2)),
        FiAssessmentOption(id: 'c', label: 'براجع اللي صار قبل ما أتصرف.', weights: FiWeights(practicalIntelligence: 2)),
        FiAssessmentOption(id: 'd', label: 'بعطي مساحة وبفهم شعوري وشعوره قبل الحوار.', weights: FiWeights(relationalWisdom: 3)),
      ],
    ),
    FiAssessmentQuestion(
      id: 'assessment-04',
      prompt: 'عندك قرار كبير وما عندك كل الصورة بعد.',
      options: [
        FiAssessmentOption(id: 'a', label: 'بسأل الكل وبضيع بين آرائهم.', weights: FiWeights(peoplePleasing: 2)),
        FiAssessmentOption(id: 'b', label: 'بحسم بسرعة حتى خلص من القلق.', weights: FiWeights(controlRigidity: 3)),
        FiAssessmentOption(id: 'c', label: 'بجمع معلومات وبحدد شو ناقصني.', weights: FiWeights(practicalIntelligence: 3)),
        FiAssessmentOption(id: 'd', label: 'بجمع معلومات وبراعي التوقيت والأطراف المتأثرة.', weights: FiWeights(relationalWisdom: 2, practicalIntelligence: 1)),
      ],
    ),
    FiAssessmentQuestion(
      id: 'assessment-05',
      prompt: 'حدا عمل شغلة بطريقة غير طريقتك، بس النتيجة مقبولة.',
      options: [
        FiAssessmentOption(id: 'a', label: 'بسكت رغم إني منزعجة.', weights: FiWeights(peoplePleasing: 2)),
        FiAssessmentOption(id: 'b', label: 'بتدخل وبصححها لتطلع مثل ما لازم.', weights: FiWeights(controlRigidity: 3)),
        FiAssessmentOption(id: 'c', label: 'إذا النتيجة جيدة بقبل الاختلاف.', weights: FiWeights(practicalIntelligence: 2)),
        FiAssessmentOption(id: 'd', label: 'بحدد إذا التفصيل أصلًا بيستاهل تدخل.', weights: FiWeights(relationalWisdom: 2, practicalIntelligence: 1)),
      ],
    ),
    FiAssessmentQuestion(
      id: 'assessment-06',
      prompt: 'شخص طلب منك جوابًا الآن.',
      options: [
        FiAssessmentOption(id: 'a', label: 'بقول نعم حتى ما أحرجه.', weights: FiWeights(peoplePleasing: 3)),
        FiAssessmentOption(id: 'b', label: 'بعطي جوابي فورًا وما بطولها.', weights: FiWeights(controlRigidity: 2)),
        FiAssessmentOption(id: 'c', label: 'بطلب وقت إذا القرار يحتاج.', weights: FiWeights(practicalIntelligence: 2)),
        FiAssessmentOption(id: 'd', label: 'أول شي بحدد: هل القرار فعلًا مستعجل؟', weights: FiWeights(relationalWisdom: 2, practicalIntelligence: 1)),
      ],
    ),
    FiAssessmentQuestion(
      id: 'assessment-07',
      prompt: 'صار خلاف بين شخصين قريبين منك.',
      options: [
        FiAssessmentOption(id: 'a', label: 'بحس لازم أصلح بينهم.', weights: FiWeights(peoplePleasing: 3)),
        FiAssessmentOption(id: 'b', label: 'باخد صف الشخص اللي بشوفه صح.', weights: FiWeights(controlRigidity: 2)),
        FiAssessmentOption(id: 'c', label: 'بسمع قبل ما أعطي رأيي.', weights: FiWeights(practicalIntelligence: 2)),
        FiAssessmentOption(id: 'd', label: 'بحدد أولًا إذا إلي دور أصلًا.', weights: FiWeights(relationalWisdom: 3)),
      ],
    ),
    FiAssessmentQuestion(
      id: 'assessment-08',
      prompt: 'شخص انتقد قرار إلك.',
      options: [
        FiAssessmentOption(id: 'a', label: 'بشك بحالي وبغير رأيي بسرعة.', weights: FiWeights(peoplePleasing: 3)),
        FiAssessmentOption(id: 'b', label: 'بدافع عن نفسي فورًا.', weights: FiWeights(controlRigidity: 3)),
        FiAssessmentOption(id: 'c', label: 'بشوف إذا النقد فيه معلومة مفيدة.', weights: FiWeights(practicalIntelligence: 3)),
        FiAssessmentOption(id: 'd', label: 'بفصل بين نبرته وبين المعلومة وبقرر شو آخد منها.', weights: FiWeights(relationalWisdom: 3)),
      ],
    ),
    FiAssessmentQuestion(
      id: 'assessment-09',
      prompt: 'شغلة مهمة عم تمشي أبطأ من توقعاتك.',
      options: [
        FiAssessmentOption(id: 'a', label: 'بخاف الناس يعتبروني مقصرة.', weights: FiWeights(peoplePleasing: 2)),
        FiAssessmentOption(id: 'b', label: 'بضغط على حالي والناس لتخلص أسرع.', weights: FiWeights(controlRigidity: 3)),
        FiAssessmentOption(id: 'c', label: 'براجع الخطة والأسباب.', weights: FiWeights(practicalIntelligence: 3)),
        FiAssessmentOption(id: 'd', label: 'بسأل إذا المشكلة فعلًا بالبطء أو باستعجالي.', weights: FiWeights(relationalWisdom: 2, practicalIntelligence: 1)),
      ],
    ),
    FiAssessmentQuestion(
      id: 'assessment-10',
      prompt: 'حدا ساعدك بطريقة مو مثالية.',
      options: [
        FiAssessmentOption(id: 'a', label: 'بجامله وبعدين بعيدها لحالي.', weights: FiWeights(peoplePleasing: 2)),
        FiAssessmentOption(id: 'b', label: 'بركز على التفاصيل اللي غلط.', weights: FiWeights(controlRigidity: 3)),
        FiAssessmentOption(id: 'c', label: 'بشكره وبعطي ملاحظة إذا مهمة.', weights: FiWeights(practicalIntelligence: 2)),
        FiAssessmentOption(id: 'd', label: 'بقدر المساعدة وبميز بين المهم والمثالية.', weights: FiWeights(relationalWisdom: 3)),
      ],
    ),
    FiAssessmentQuestion(
      id: 'assessment-11',
      prompt: 'أنتِ غضبانة جدًا وأمامك قرار مهم.',
      options: [
        FiAssessmentOption(id: 'a', label: 'ممكن أتنازل حتى ينتهي الخلاف.', weights: FiWeights(peoplePleasing: 3)),
        FiAssessmentOption(id: 'b', label: 'بحسم فورًا لأنه لازم ينتهي.', weights: FiWeights(controlRigidity: 3)),
        FiAssessmentOption(id: 'c', label: 'بأجل القرار لحد ما أهدأ.', weights: FiWeights(practicalIntelligence: 3)),
        FiAssessmentOption(id: 'd', label: 'بهدأ، بفهم شو تحت الغضب، وبعدين بختار التوقيت.', weights: FiWeights(relationalWisdom: 3, practicalIntelligence: 1)),
      ],
    ),
    FiAssessmentQuestion(
      id: 'assessment-12',
      prompt: 'قبل محادثة صعبة، شو أكتر شي بيشغلك؟',
      options: [
        FiAssessmentOption(id: 'a', label: 'المهم ما يزعل مني.', weights: FiWeights(peoplePleasing: 3)),
        FiAssessmentOption(id: 'b', label: 'المهم أثبت وجهة نظري.', weights: FiWeights(controlRigidity: 3)),
        FiAssessmentOption(id: 'c', label: 'المهم أوصل لقرار واضح.', weights: FiWeights(practicalIntelligence: 2)),
        FiAssessmentOption(id: 'd', label: 'المهم أعرف نيتي وأختار أفضل وقت وطريقة.', weights: FiWeights(relationalWisdom: 3)),
      ],
    ),
  ];

  static const models = <FiModelDescriptor>[
    FiModelDescriptor(
      routeId: 'feminine-naivety',
      title: 'السذاجة الأنثوية',
      shortTitle: 'التنازل عن الذات',
      description: 'لما رضا الناس أو الخوف من الرفض يدخل قبل قرارك وحدودك.',
      strength: 'عندك تعاطف واهتمام بالعلاقة.',
      growthEdge: 'تبقي طيبة بدون ما تتركي نفسك.',
      icon: Icons.favorite_outline_rounded,
    ),
    FiModelDescriptor(
      routeId: 'masculine-rigidity',
      title: 'التعصب الذكوري',
      shortTitle: 'القوة المتعبة',
      description: 'لما الاستعجال والسيطرة والتصلب بالرأي يضيقوا الخيارات ويزيدوا الحمل.',
      strength: 'عندك قرار وقوة وقدرة على الإنجاز.',
      growthEdge: 'تحافظي على القوة مع مرونة وتوقيت أذكى.',
      icon: Icons.bolt_rounded,
    ),
    FiModelDescriptor(
      routeId: 'masculine-intelligence',
      title: 'الذكاء الذكوري',
      shortTitle: 'القرار العملي',
      description: 'عندك قدرة جيدة على التنظيم، الأولويات، والقرار، والمرحلة الجاية تضيف حكمة عاطفية وعلاقية.',
      strength: 'منطق عملي وقدرة على التوقف قبل التصرف.',
      growthEdge: 'إضافة الوقت والمسافة والمشاعر والنية للقرار.',
      icon: Icons.psychology_alt_rounded,
    ),
    FiModelDescriptor(
      routeId: 'feminine-intelligence-advanced',
      title: 'الذكاء الأنثوي',
      shortTitle: 'الحكمة العلاقية',
      description: 'الوقت والمسافة وفهم المشاعر والنية حاضرة عندك بدرجة جيدة، وهون منعمّق التطبيق بالمواقف الأصعب.',
      strength: 'قدرة على رؤية أكثر من طرف وحماية الهدف والعلاقة معًا.',
      growthEdge: 'تحويل المهارة إلى عادة ثابتة بالمواقف الحقيقية.',
      icon: Icons.auto_awesome_rounded,
    ),
  ];

  static const feminineNaivetyRoute = FiRoute(
    id: 'feminine-naivety',
    title: 'من التنازل عن الذات إلى الذكاء الأنثوي',
    resultTitle: 'نقطة بدايتك أقرب إلى التنازل عن الذات لإرضاء الآخرين',
    resultBody: 'واضح إنك أحيانًا بتحافظي على راحة الناس حتى لو صار الثمن راحتك أو حقك. رحلتك مو لتصبحي قاسية؛ هي لتبقي طيبة بدون ما تتركي نفسك.',
    goal: 'أبني حدودًا وقرارًا داخليًا واضحًا، وبعدها أضيف التوقيت والمسافة وفهم المشاعر والنية.',
    lessons: [
      FiLesson(
        id: 'naivety-01',
        title: 'وين عم أترك نفسي؟',
        subtitle: 'ألاحظ اللحظة اللي رأي الآخر بيدخل قبل قراري.',
        insight: 'أحيانًا المشكلة مو إنك ما بتعرفي شو بدك؛ المشكلة إن خوف زعل الآخر بيصير أعلى من صوتك الداخلي.',
        prompt: 'فكري بموقف وافقتِ فيه وأنتِ من جواك ما كنتِ بدك. شو كان أقوى سبب؟',
        practice: 'اليوم، قبل أي "نعم" مو واضحة، خدي وقفة قصيرة واسألي: لو ما خفت من زعله، شو كان قراري؟',
        choices: ['الخوف من زعله', 'الشعور بالذنب', 'ما عرفت قول لا', 'ما كان عندي وقت أفكر'],
      ),
      FiLesson(
        id: 'naivety-02',
        title: 'هل هاد فعلًا مسؤوليتي؟',
        subtitle: 'أفرق بين مسؤوليتي، مساعدتي، وحياة الآخرين.',
        insight: 'المساعدة اختيار؛ أما حمل نتيجة قرارات أشخاص بالغين فمو دائمًا مسؤوليتك.',
        prompt: 'اكتبي موضوع عم يشغل بالك. أي جزء منه تحت سيطرتك فعلًا؟',
        practice: 'قسمي الموقف اليوم لثلاث دوائر: مسؤوليتي / بقدر أساعد / ما بقدر أتحكم فيه.',
      ),
      FiLesson(
        id: 'naivety-03',
        title: 'أقول لا بدون ما أكره حالي',
        subtitle: 'حدود واضحة بدون عدوانية.',
        insight: 'الحد الواضح مو قسوة. الوضوح بيقلل المساحة اللي بتخليكي توافقي تحت الضغط.',
        prompt: 'أي جملة أقرب لحد بدك تتعلمي تقوليها هالأسبوع؟',
        practice: 'اختاري موقفًا خفيفًا وقولي "لا" بجملة قصيرة بدون شرح طويل.',
        choices: ['ما بقدر اليوم', 'بدي وقت أفكر', 'هالطريقة بالكلام ما بتناسبني', 'رح ساعد بالجزء اللي بقدر عليه فقط'],
      ),
      FiLesson(
        id: 'naivety-04',
        title: 'إذا زعل… هل يعني إني غلط؟',
        subtitle: 'أتحمل عدم الراحة بدون ما أرجع عن قرار مناسب.',
        insight: 'انزعاجك أو زعل الطرف الثاني مو دليل تلقائي إن قرارك خطأ. أحيانًا هو فقط ثمن مؤقت لتغيير نمط قديم.',
        prompt: 'شو الفكرة اللي بترجع تدفعك للتراجع لما حدا يزعل منك؟',
        practice: 'بعد حد مناسب، انتظري عشر دقائق قبل أي تراجع أو تبرير إضافي. لاحظي الشعور بدون ما تغيري القرار فورًا.',
      ),
      FiLesson(
        id: 'naivety-05',
        title: 'أنا شو أولويتي؟',
        subtitle: 'أختار بناءً على وقتي وطاقتي وقيمي، مو فقط رضا الناس.',
        insight: 'كل "نعم" إلها كلفة. القرار الأذكى بيشوف شو رح تتنازلي عنه مقابل الموافقة.',
        prompt: 'شو الشي اللي غالبًا بتضحي فيه لما توافقِي بسرعة: وقتك، راحتك، مالك، ولا خطة مهمة إلك؟',
        practice: 'قبل طلب واحد اليوم اسألي: هل عندي وقت؟ طاقة؟ وهل رح أكون راضية عن هالقرار بعد أسبوع؟',
      ),
      FiLesson(
        id: 'naivety-06',
        title: 'أجمع أدلة احترام الذات',
        subtitle: 'التقدير الداخلي يصير مبني على سلوك حقيقي.',
        insight: 'مو مطلوب تقنعي نفسك إنك رائعة بكلام فارغ. اجمعي أدلة صغيرة على إنك عم تختاري بوعي.',
        prompt: 'شو عملتي مؤخرًا وتحترمي نفسك عليه، حتى لو كان صغير؟',
        practice: 'لمدة 5 أيام اكتبي موقفًا واحدًا احترمتِ فيه وقتك، حدودك، أو قرارك.',
      ),
      FiLesson(
        id: 'naivety-07',
        title: 'جسر الذكاء الأنثوي',
        subtitle: 'الوقت + المسافة + المشاعر + النية.',
        insight: 'حماية الذات هي البداية، مو النهاية. الحكمة تظهر لما تحافظي على حقك وتختاري بنفس الوقت التوقيت والمسافة والنية الأنسب.',
        prompt: 'بموقف حساس قريب: أي عنصر غالبًا بتنسيه؟ الوقت، المسافة، شعورك، شعور الآخر، ولا نيتك؟',
        practice: 'طبقي الأربع أسئلة على موقف واحد: هل الآن الوقت؟ شو المسافة؟ شو المشاعر المحتملة؟ شو نيتي؟',
      ),
    ],
  );

  static const masculineRigidityRoute = FiRoute(
    id: 'masculine-rigidity',
    title: 'من الصراع والسيطرة إلى الذكاء الأنثوي',
    resultTitle: 'نقطة بدايتك أقرب إلى القوة المتعبة والتصلب تحت الضغط',
    resultBody: 'عندك قدرة واضحة على القرار والإنجاز، بس أحيانًا الاستعجال أو التشبث بالطريقة أو حمل كل شيء لحالك بيخلي القوة مكلفة. الرحلة رح تحافظ على قوتك وتضيف إلها سعة ومرونة.',
    goal: 'أحافظ على القوة والوضوح مع وقت أذكى، خيارات أوسع، تفويض، تقدير، ومساحة للمشاعر والنية.',
    lessons: [
      FiLesson(
        id: 'rigidity-01',
        title: 'هل فعلًا لازم الآن؟',
        subtitle: 'أفرق بين الطارئ وبين عدم راحتي مع الانتظار.',
        insight: 'الاستعجال ممكن يسرق منك معلومة أو توقيت كان رح يغير النتيجة.',
        prompt: 'شو أكتر شي بخوفك إذا القرار ما انحسم اليوم؟',
        practice: 'اختاري قرارًا غير طارئ ومرريه على 4 أسئلة: خطر حقيقي؟ كل المعلومات؟ أنا هادئة؟ الطرف الآخر جاهز؟',
      ),
      FiLesson(
        id: 'rigidity-02',
        title: 'مين قال؟',
        subtitle: 'أفتح احتمال ثالث ورابع بدل الأبيض والأسود.',
        insight: 'كلمة "لازم" أحيانًا بتكون قاعدة متعلمة أو خوف، مو حقيقة.',
        prompt: 'اكتبي جملة فيها "لازم" عم تكرريها هالفترة. مين قال إنها لازم بهالطريقة وبهالتوقيت؟',
        practice: 'طلعي 3 بدائل حقيقية لنفس الموقف، حتى لو ما اخترتيهم بالنهاية.',
      ),
      FiLesson(
        id: 'rigidity-03',
        title: 'الهدف… ولا طريقتي؟',
        subtitle: 'أميز النتيجة المطلوبة عن حاجتي إن كل شي يصير بأسلوبي.',
        insight: 'إذا النتيجة مقبولة، اختلاف الطريقة مو دائمًا مشكلة تحتاج تصحيح.',
        prompt: 'وين بتتدخلي غالبًا رغم إن النتيجة بالنهاية مقبولة؟',
        practice: 'اختاري تفصيلًا واحدًا اليوم واتركيه ينعمل بطريقة غير طريقتك إذا النتيجة آمنة ومقبولة.',
      ),
      FiLesson(
        id: 'rigidity-04',
        title: 'أفوض بدون مراقبة',
        subtitle: 'أسمح للمساعدة تكون مساعدة فعلًا.',
        insight: 'التفويض الحقيقي مو إنك تعطي المهمة وبعدين تديري كل خطوة من فوق كتف الشخص.',
        prompt: 'شو أصعب شي عليك بالتفويض: الانتظار، الثقة، اختلاف الطريقة، ولا نتيجة 80%؟',
        practice: 'فوضي مهمة صغيرة، وحددي النتيجة المطلوبة فقط. لا تعيديها لمجرد إنها مختلفة.',
      ),
      FiLesson(
        id: 'rigidity-05',
        title: 'مساعدة ولا نقد؟',
        subtitle: 'أعرف إمتى الملاحظة مفيدة وإمتى هي تفريغ ضيق.',
        insight: 'كثرة التصحيح بتخلي الناس يبتعدوا عن دورهم حتى لو كانت نيتك التحسين.',
        prompt: 'قبل آخر ملاحظة أعطيتيها: هل الخطأ كان مؤثر فعلًا؟ وهل كان لازم ينقال بنفس اللحظة؟',
        practice: 'استخدمي اليوم فلتر 3 أسئلة: مؤثر؟ لازم الآن؟ هدفي تحسين ولا تفريغ؟',
      ),
      FiLesson(
        id: 'rigidity-06',
        title: 'أربح النقاش ولا أحمي الهدف؟',
        subtitle: 'أقيس النجاح بالنتيجة، مو بإثبات مين الصح.',
        insight: 'ممكن تكوني صح وتخسري الشي اللي كنتِ داخلة تحميه. الحكمة بتسأل عن الربح والخسارة معًا.',
        prompt: 'بخلاف قريب، شو كان هدفك الحقيقي قبل ما يتحول الحوار لإثبات وجهة نظر؟',
        practice: 'اعملي لوحتين: إذا كملت بنفس الأسلوب شو بربح/بخسر؟ وإذا غيرت الأسلوب بدون ما أترك حقي شو بربح/بخسر؟',
      ),
      FiLesson(
        id: 'rigidity-07',
        title: 'مو لازم أشيل كل شي',
        subtitle: 'أرتب الحمل بدل ما أعيش كأنه كله حياة أو موت.',
        insight: 'الراحة هون قرار إداري: أعرف شو لازم أنا، شو ممكن أفوض، شو يتأجل، وشو ينحذف.',
        prompt: 'من كل اللي شايلتيه هالأيام، شو الشي اللي فعلًا ما لازم يكون عليك؟',
        practice: 'اعملي 4 قوائم: لازم أنا / أفوض / أأجل / أحذف. انقلي مهمة واحدة على الأقل من "لازم أنا".',
      ),
      FiLesson(
        id: 'rigidity-08',
        title: 'أسمح للناس يكون إلهم دور',
        subtitle: 'طلب الرأي والمساعدة ما يعني تسليم القرار.',
        insight: 'الدعم مو ضد الاستقلال. ممكن شخص يسمع، شخص يساعد عمليًا، وشخص يعطي خبرة، وإنتِ تظلي صاحبة القرار.',
        prompt: 'مين شخص واحد آمن ممكن يكون إله دور صغير بدل ما تعملي كل شي لوحدك؟',
        practice: 'اطلبي هذا الأسبوع دعمًا محددًا: سماع، رأي، أو مساعدة عملية، بدون ما تطلبي من الشخص يقرر عنك.',
      ),
      FiLesson(
        id: 'rigidity-09',
        title: 'جسر الذكاء الأنثوي',
        subtitle: 'الوقت + المسافة + المشاعر + النية.',
        insight: 'قوتك ما لازم تختفي. المطلوب تصير أهدأ وأوسع: أعرف إمتى أتحرك، إمتى أبتعد خطوة، شو عم أشعر، وشو هدفي الحقيقي.',
        prompt: 'بموقف حساس قريب، أي عنصر غالبًا بتهمليه: الوقت، المسافة، شعورك، شعور الآخر، ولا نيتك؟',
        practice: 'قبل حوار مهم مرري الموقف على الأربع: هل الآن الوقت؟ شو المسافة؟ شو المشاعر؟ شو نيتي؟',
      ),
    ],
  );

  static const masculineIntelligenceRoute = FiRoute(
    id: 'masculine-intelligence',
    title: 'من الذكاء العملي إلى الذكاء الأنثوي',
    resultTitle: 'عندك قاعدة قوية من الذكاء العملي',
    resultBody: 'إجاباتك بتبين قدرة جيدة على التوقف، جمع المعلومات، وترتيب القرار. رحلتك ما رح ترجعك لورا؛ رح تضيف للمنطق توقيتًا ومشاعر ومرونة وعلاقات أذكى.',
    goal: 'أحوّل القرار الجيد إلى قرار حكيم يراعي المعلومات والمشاعر والتوقيت والنتائج معًا.',
    lessons: [
      FiLesson(
        id: 'masc-intel-01',
        title: 'من الانفعال إلى الاستجابة',
        subtitle: 'أترك مساحة صغيرة قبل القرار لما يرتفع الشعور.',
        insight: 'القرار القوي مو القرار الأسرع؛ هو القرار اللي ما تختطفه لحظة غضب أو خوف.',
        prompt: 'لما تكوني منفعلة، شو أكثر شي بيخليك تحسمي بسرعة؟',
        practice: 'بأول موقف مشحون، سمّي الشعور وشدته من 1 إلى 10 وخدي وقفة قبل أي قرار غير طارئ.',
        choices: ['بدي أخلص من التوتر', 'بخاف أغير رأيي', 'بحس لازم أكون حاسمة', 'بصعب علي أترك الموضوع معلق'],
      ),
      FiLesson(
        id: 'masc-intel-02',
        title: 'أوسع خريطة القرار',
        subtitle: 'معلومات + خيارات + نتائج قصيرة وبعيدة.',
        insight: 'أحيانًا القرار منطقي ضمن معلومتين، لكن يتغير لما نضيف معلومة ثالثة أو أثر بعيد المدى.',
        prompt: 'بقرار قريب، شو المعلومة اللي لو عرفتيها ممكن تغير اختيارك؟',
        practice: 'قبل قرار مهم اكتبي: شو بعرف؟ شو ما بعرف؟ شو 3 خيارات؟ وشو أثر كل خيار بعد أسبوع وبعد 6 أشهر؟',
      ),
      FiLesson(
        id: 'masc-intel-03',
        title: 'التوقيت جزء من القرار',
        subtitle: 'نفس الكلام ممكن ينجح أو يفشل حسب اللحظة.',
        insight: 'صحة الفكرة ما بتلغي أهمية توقيتها. الشخص المتعب أو المنفعل ممكن يسمع نفس الكلام بطريقة مختلفة.',
        prompt: 'بآخر حوار صعب، هل المشكلة كانت بالمحتوى ولا بالتوقيت كمان؟',
        practice: 'قبل حوار واحد اليوم اسألي: هل أنا جاهزة؟ هل هو جاهز؟ وإذا لا، متى وقت أفضل محدد؟',
      ),
      FiLesson(
        id: 'masc-intel-04',
        title: 'أقرأ الشعور بدون ما أخمن',
        subtitle: 'أحول تفسير مشاعر الآخر إلى احتمال يحتاج دليل.',
        insight: 'فهم الطرف الآخر مو قراءة أفكاره. منقول "ممكن" ونبحث عن دليل أو نسأل.',
        prompt: 'شو أكثر شعور بتفترضي بسرعة إنه عند الطرف الآخر وقت الخلاف؟',
        practice: 'اختاري موقفًا واكتبي: شو أتوقع إنه يشعر؟ شو الدليل؟ شو السؤال اللي ممكن يوضح بدل الافتراض؟',
      ),
      FiLesson(
        id: 'masc-intel-05',
        title: 'النية تقود الأسلوب',
        subtitle: 'أعرف شو بدي قبل ما أبدأ الكلام.',
        insight: 'لما تكون النية غامضة، الحوار ممكن يتحول من حل لإثبات أو دفاع بدون ما ننتبه.',
        prompt: 'قبل موقف مهم: بدك فهم، حل، حد، تعبير، ولا إثبات وجهة نظر؟',
        practice: 'اكتبي نيتك بجملة واحدة قبل الحوار، وبعده راجعي: هل أسلوبك خدمها فعلًا؟',
      ),
    ],
  );

  static const feminineIntelligenceRoute = FiRoute(
    id: 'feminine-intelligence-advanced',
    title: 'تعميق الذكاء الأنثوي',
    resultTitle: 'الذكاء الأنثوي هو الأقرب حاليًا',
    resultBody: 'هذا مو معناه إن الرحلة خلصت. عندك أساس جيد، وهون منحوّل الوقت والمسافة والمشاعر والنية إلى مهارة ثابتة حتى بالمواقف الأصعب.',
    goal: 'أعمّق الحكمة العلاقية وأثبتها بالمواقف الحقيقية بدل ما تبقى معرفة نظرية.',
    lessons: [
      FiLesson(
        id: 'fem-intel-01',
        title: 'فن الوقت',
        subtitle: 'أختار متى أتكلم ومتى أنتظر بوعي.',
        insight: 'التأخير مو دائمًا هروب، والسرعة مو دائمًا شجاعة. الحكمة تحدد التوقيت حسب الهدف والاستعداد.',
        prompt: 'بأي نوع مواقف بيكون اختيار التوقيت أصعب عليك؟',
        practice: 'اختاري حوارًا واحدًا وحددي قبل دخوله: ليش الآن؟ وشو العلامة اللي بتقول إن الوقت مناسب؟',
      ),
      FiLesson(
        id: 'fem-intel-02',
        title: 'فن المسافة',
        subtitle: 'أقرب للفهم أو أبتعد للصورة الأكبر حسب الحاجة.',
        insight: 'المسافة الذكية مو عقاب ولا اختفاء؛ هي مقدار القرب اللي يساعدك تشوفي الصورة بدون ما تغرقي فيها.',
        prompt: 'لما تتوتري بعلاقة، بتميلِي غالبًا للقرب الزائد ولا الابتعاد الزائد؟',
        practice: 'بموقف واحد حددي المسافة المطلوبة: دقائق، ساعات، سؤال توضيحي، أو اقتراب للحوار بدل التخمين.',
      ),
      FiLesson(
        id: 'fem-intel-03',
        title: 'مشاعري ومشاعره',
        subtitle: 'أفهم نفسي وأترك شعور الآخر احتمالًا قابلًا للتحقق.',
        insight: 'المشاعر معلومة مهمة، لكن تفسيرنا لمشاعر الآخرين يظل احتمالًا حتى نسأل أو نجد دليلًا.',
        prompt: 'شو شعورك اللي غالبًا يختفي تحت الغضب أو البرود؟',
        practice: 'اكتبي في موقف: أنا أشعر بـ… وأحتاج… وأتوقع أنه يشعر بـ… والدليل عندي هو…',
      ),
      FiLesson(
        id: 'fem-intel-04',
        title: 'وضوح النية',
        subtitle: 'أحمي الهدف قبل ما يشدني الانفعال.',
        insight: 'لما أعرف شو بدي من الحوار، بصير أسهل أختار الكلمات والتوقيت والحدود اللي تخدم هالهدف.',
        prompt: 'شو النية اللي بتضيع منك أسرع وقت الخلاف؟',
        practice: 'قبل موقف حقيقي اكتبي نيتك، وبعده قيّمي من 1 إلى 10: قديش تصرفك خدمها؟',
      ),
      FiLesson(
        id: 'fem-intel-05',
        title: 'القرار المتوازن',
        subtitle: 'حقي + هدفي + العلاقة + الواقع.',
        insight: 'الحكمة ما تعني إرضاء الجميع؛ تعني إنك تشوفي أكبر قدر ممكن من الصورة قبل ما تختاري.',
        prompt: 'لما تتعارض مصلحتك مع راحة شخص قريب، شو الشي اللي بدك توازنيه بشكل أحسن؟',
        practice: 'مرري قرارًا واحدًا على أربع عدسات: حقي، هدفي، أثره على العلاقة، والواقع العملي. بعدها اختاري.',
      ),
    ],
  );

  static const allRoutes = <FiRoute>[
    feminineNaivetyRoute,
    masculineRigidityRoute,
    masculineIntelligenceRoute,
    feminineIntelligenceRoute,
  ];

  static FiRoute routeById(String id) {
    if (id == masculineRigidityRoute.id) return masculineRigidityRoute;
    if (id == masculineIntelligenceRoute.id) return masculineIntelligenceRoute;
    if (id == feminineIntelligenceRoute.id || id == 'advanced') return feminineIntelligenceRoute;
    return feminineNaivetyRoute;
  }

  static FiModelDescriptor modelByRouteId(String id) {
    final normalized = id == 'advanced' ? feminineIntelligenceRoute.id : id;
    return models.firstWhere(
      (model) => model.routeId == normalized,
      orElse: () => models.first,
    );
  }

}
