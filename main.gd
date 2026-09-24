extends Node2D

var player_health: int = 100
var player_max_health: int = 100
var ai_health: int = 100
var ai_max_health: int = 100
var ai_hp_bar: ProgressBar
var ai_hp_label: Label
var current_turn: String = "player"
var player_cards: Array = []
var ai_cards: Array = []
var is_game_over: bool = false
var round_count: int = 1
var current_difficulty: String = "easy"
var chaos_turns_left: int = 0
var chaos_turns_remaining: int = 0
var last_devil_round: int = 0
var chaos_label: Label
var game_over_panel: Panel
var result_label: Label
var play_again_btn: Button
var exit_game_over_btn: Button
var round_notification_label: Label
var profile_popup
var modes_panel: Panel
var difficulty_panel: Panel
var player_count_panel: Panel
var friends_popup: Panel
var room_create_panel: Panel
var room_join_panel: Panel
var gameplay_bg: Control
var profile_btn: Button
var play_btn: Button
var rules_btn: Button
var rules_popup: Panel
var rules_close_btn: Button
var main_bg: TextureRect
var lang_btn: Button
var add_friend_btn: Button
var my_username: String = "Name"
var my_player_id: String = "ID-88492"
var my_friends: Array = []
var friend_input: LineEdit
var friends_list_label: Label
var status_label: Label
var avatar_btn: Button
var file_dialog: FileDialog
var android_image_plugin: Object = null
var current_avatar_texture: Texture2D = null
var player_hp_bar: ProgressBar
var player_hp_label: Label
var current_lang: String = "ar"
var ai_played_this_round: Array = []
var player_played_this_round: Array = []
var light_popup: Panel
var light_popup_title: Label
var light_popup_buttons: Array = []
var light_popup_is_open: bool = false
var light_popup_callback: Callable
var eye_popup: Panel
var eye_popup_title: Label
var eye_popup_buttons: Array = []
var eye_popup_is_open: bool = false

var rules_text_ar = """📜 قواعد اللعبة 📜

🎯 الهدف:
ابقى آخر لاعب بصحة أكبر بعد 3 روندات.

🎮 طريقة اللعب:
• كل لاعب عنده 7 كروت عشوائية.
• تلعب أنت أولاً، ثم الذكاء الاصطناعي، ثم أنت... وهكذا.
• اضغط على الكرت لتراه، ثم يقلب لضهره تلقائياً.
• الكرت الملعوب لا يعود للرزمة.

🃏 شرح الكروت:

💀 الموت:
يخصم 50 من صحتك. لو وصلت لـ 0 تخسر فوراً.

🔄 العب تاني:
يمنحك دوراً إضافياً. تلعب كرت آخر بعد هذا الكرت.

🚫 لاشئ:
لا يفعل أي شي. مجرد كرت محايد.

✨ نور البعث:
يسمح لك باستخدام كرت استخدمه الخصم.
تظهر قائمة بالكروت، اختر واحداً ليتم تنفيذ تأثيره عليك.

👁️ عين رع:
يكشف لك كرت من كروتك المخفية لمدة 10 ثواني.
مفيد لمعرفة مكان كرت الموت.

🌊 روح النيل:
يزيد صحتك 50 نقطة.
لو صحتك 50 تصبح 100، ولو 100 تصبح 150.

😈 شيطان الفوضى:
الأقوى! يتحكم بك لمدة دور واحد فقط.
الذكاء الاصطناعي يلعب بدالك بذكاء خارق.

⏳ نظام الأدوار:
• دورك → دور الذكاء الاصطناعي → دورك → وهكذا.
• كرت "العب تاني" يعطيك دوراً إضافياً.
• عند نفاذ كروت أحد الطرفين، ينتهي الروند وتبدأ روند جديدة.

🏆 الفوز والخسارة:
• تنتهي اللعبة لو صحتك وصلت لـ 0 (تخسر).
• أو لو صحة الذكاء الاصطناعي وصلت لـ 0 (تكسب).
• لو انتهت 3 روندات، الفائز من لديه صحة أكثر.

⚠️ تحذير:
شيطان الفوضى لا يرحم! لو ظهر لك، أنت في خطر."""

var rules_text_en = """📜 Game Rules 📜

🎯 Objective:
Be the last player with the highest health after 3 rounds.

🎮 How to Play:
• Each player gets 7 random cards.
• You play first, then AI, then you... etc.
• Click on a card to see it, then it flips back automatically.
• Played cards don't return to the deck.

🃏 Card Descriptions:

💀 Death:
Reduces your health by 50. If it hits 0, you lose.

🔄 Play Again:
Gives you an extra turn. Play another card after this one.

🚫 Nothing:
Does nothing. A neutral card.

✨ Light of Resurrection:
Lets you use a card the opponent used.
A menu appears with the cards, pick one and its effect applies to you.

👁️ Eye of Ra:
Reveals one of your hidden cards for 10 seconds.
Useful to know where the Death card is.

🌊 Nile's Soul:
Increases your health by 50.
If health is 50 it becomes 100, if 100 it becomes 150.

😈 Devil of Chaos:
The strongest! Controls you for one turn only.
AI plays for you with super intelligence.

⏳ Turn System:
• Your turn → AI turn → Your turn → etc.
• "Play Again" card gives you an extra turn.
• When a player runs out of cards, the round ends and a new one begins.

🏆 Win and Lose:
• Game ends if your health reaches 0 (you lose).
• Or if AI health reaches 0 (you win).
• After 3 rounds, whoever has more health wins.

⚠️ Warning:
The Devil of Chaos shows no mercy! If it appears, you're in danger."""

var texts = {
	"ar": {"play": "الــعــب", "choose_mode": "--- اختر نمط اللعب ---", "vs_ai": "🤖 اللعب ضد الذكاء الاصطناعي", "create_room": "🏠 إنشاء روم جديدة", "join_room": "🚪 دخول روم برمز", "close": "X", "back": "رجوع", "create_room_title": "--- إنشاء روم جديدة ---", "room_code": "رمز الروم: RM-9921", "start_game": "ابدأ الجيم", "join_room_title": "--- الانضمام إلى روم ---", "room_code_placeholder": "اكتب كود الروم هنا...", "enter_room": "دخول الروم", "difficulty_title": "--- اختر مستوى الصعوبة ---", "easy": "🟢 ســهــل", "medium": "🟡 مــتــوســط", "hard": "🔴 صــعــب", "player_count_title": "--- اختر عدد المنافسين ---", "one_vs_one": "👤 تلعب ضد 1", "profile_title": "الملف الشخصي", "change_avatar": "🖼️\nتغيير الصورة", "your_id": "الـ ID: ", "change_name": "تغيير الاسم:", "add_friend_title": "إضافة صديق", "friend_placeholder": "اكتب اسم صديقك...", "search_add": "بحث وإضافة", "friends_list": "قائمة الأصدقاء:\n", "no_friends": "(لا يوجد أصدقاء)", "write_name": "⚠️ اكتب اسم أو ID!", "cannot_add_self": "⚠️ لا يمكنك إضافة نفسك!", "already_exists": "⚠️ ", "added_success": "✅ تم إضافة ", "success_end": " بنجاح!", "ai_cards": "🤖 كروت الذكاء الاصطناعي", "your_cards": "👤 كروتك (اضغط لاختيار كارت)", "exit": "✕ خروج", "play_again": "🔄 العب مرة أخرى", "quit": "🚪 خروج", "you_win": "🎉 أنت كسبت!", "you_lose": "💀 أنت خسرت!", "draw": "🤝 تعادل!", "round_end": "✅ الروند %d خلص!\n➡️ انتقل للروند %d", "light_title": "✨ اختر كارت", "eye_title": "👁️ اختر كارت", "eye_button": "كارت %d", "card_death": "💀 الموت", "card_again": "🔄 العب تاني", "card_nothing": "🚫 لاشئ", "card_light": "✨ نور البعث", "card_eye": "👁️ عين رع", "card_spirit": "🌊 روح النيل", "card_devil": "😈 شيطان الفوضى", "chaos_msg": "😈 شيطان الفوضى يتحكم بك!\nباقي %d أدوار", "rules_btn": "📜 القواعد", "rules_title": "📜 قواعد اللعبة"},
	"en": {"play": "PLAY", "choose_mode": "--- Choose Game Mode ---", "vs_ai": "🤖 Play vs AI", "create_room": "🏠 Create New Room", "join_room": "🚪 Join Room with Code", "close": "X", "back": "Back", "create_room_title": "--- Create New Room ---", "room_code": "Your Room Code: RM-9921", "start_game": "Start Game", "join_room_title": "--- Join a Room ---", "room_code_placeholder": "Enter room code here...", "enter_room": "Enter Room", "difficulty_title": "--- Choose Difficulty ---", "easy": "🟢 Easy", "medium": "🟡 Medium", "hard": "🔴 Hard", "player_count_title": "--- Choose Opponents ---", "one_vs_one": "👤 Play vs 1", "profile_title": "Profile", "change_avatar": "🖼️\nChange Picture", "your_id": "Your ID: ", "change_name": "Change Name:", "add_friend_title": "Add Friend", "friend_placeholder": "Enter friend's name or ID...", "search_add": "Search & Add", "friends_list": "Friends List:\n", "no_friends": "(No friends yet)", "write_name": "⚠️ Write a name or ID to search!", "cannot_add_self": "⚠️ You can't add yourself!", "already_exists": "⚠️ ", "added_success": "✅ Added ", "success_end": " successfully!", "ai_cards": "🤖 AI Cards", "your_cards": "👤 Your Cards (Tap to pick)", "exit": "✕ Exit", "play_again": "🔄 Play Again", "quit": "🚪 Quit", "you_win": "🎉 You Win!", "you_lose": "💀 You Lose!", "draw": "🤝 Draw!", "round_end": "✅ Round %d finished!\n➡️ Moving to Round %d", "light_title": "✨ Choose a card", "eye_title": "👁️ Choose a card", "eye_button": "Card %d", "card_death": "💀 Death", "card_again": "🔄 Play Again", "card_nothing": "🚫 Nothing", "card_light": "✨ Light of Resurrection", "card_eye": "👁️ Eye of Ra", "card_spirit": "🌊 Nile's Soul", "card_devil": "😈 Devil of Chaos", "chaos_msg": "😈 Devil of Chaos controls you!\n%d turns left", "rules_btn": "📜 Rules", "rules_title": "📜 Game Rules"}
}

var mode_title_label: Label
var ai_btn: Button
var create_room_btn: Button
var join_room_btn: Button
var modes_close_btn: Button
var cr_title: Label
var cr_code_lbl: Label
var cr_start_btn: Button
var cr_back_btn: Button
var jr_title: Label
var jr_code_input: LineEdit
var jr_enter_btn: Button
var jr_back_btn: Button
var diff_title: Label
var easy_btn: Button
var medium_btn: Button
var hard_btn: Button
var diff_back_btn: Button
var pc_title: Label
var pc_one_btn: Button
var pc_back_btn: Button
var p_title: Label
var p_id_lbl: Label
var p_name_lbl: Label
var p_close_btn: Button
var f_title: Label
var f_search_btn: Button
var f_close_btn: Button
var ai_label_ref: Label
var player_label_ref: Label

func _ready():
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
	var screen_size = get_viewport_rect().size
	_init_android_gallery_plugin()
	main_bg = TextureRect.new()
	main_bg.name = "MainBackground"
	if ResourceLoader.exists("res://bg.png"): main_bg.texture = load("res://bg.png")
	main_bg.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	main_bg.stretch_mode = TextureRect.STRETCH_SCALE
	main_bg.size = screen_size
	add_child(main_bg)
	_setup_gameplay_background(screen_size)
	_setup_health_bars(screen_size)
	play_btn = Button.new()
	play_btn.name = "PlayButton"
	play_btn.position = Vector2(screen_size.x - 220, 30)
	play_btn.size = Vector2(180, 60)
	play_btn.pressed.connect(_on_play_pressed)
	add_child(play_btn)
	profile_btn = Button.new()
	profile_btn.position = Vector2(30, screen_size.y - 80)
	profile_btn.size = Vector2(160, 50)
	profile_btn.pressed.connect(_on_profile_pressed)
	add_child(profile_btn)
	add_friend_btn = Button.new()
	add_friend_btn.text = "👤+"
	add_friend_btn.position = Vector2(200, screen_size.y - 80)
	add_friend_btn.size = Vector2(50, 50)
	add_friend_btn.pressed.connect(_on_add_friend_pressed)
	add_child(add_friend_btn)
	rules_btn = Button.new()
	rules_btn.text = "📜"
	rules_btn.position = Vector2(screen_size.x - 80, screen_size.y - 80)
	rules_btn.size = Vector2(50, 50)
	rules_btn.add_theme_font_size_override("font_size", 24)
	rules_btn.pressed.connect(_on_rules_pressed)
	add_child(rules_btn)
	_setup_rules_popup(screen_size)
	_setup_file_dialog()
	_setup_modes_panel(screen_size)
	_setup_difficulty_panel(screen_size)
	_setup_player_count_panel(screen_size)
	_setup_room_create_panel(screen_size)
	_setup_room_join_panel(screen_size)
	_setup_profile_popup(screen_size)
	_setup_friends_popup(screen_size)
	_setup_game_over_panel(screen_size)
	_setup_round_notification(screen_size)
	_setup_light_popup(screen_size)
	_setup_eye_popup(screen_size)
	_setup_chaos_label(screen_size)
	_setup_language_button()
	_update_all_texts()

func _setup_rules_popup(screen_size):
	rules_popup = Panel.new()
	rules_popup.size = screen_size
	rules_popup.visible = false
	rules_popup.add_theme_stylebox_override("panel", StyleBoxEmpty.new())
	
	var bg_rect = ColorRect.new()
	bg_rect.color = Color(0, 0, 0, 0.85)
	bg_rect.size = screen_size
	bg_rect.mouse_filter = Control.MOUSE_FILTER_STOP
	rules_popup.add_child(bg_rect)
	
	var panel_width = screen_size.x - 60
	var panel_height = screen_size.y - 120
	var inner_panel = Panel.new()
	inner_panel.add_theme_stylebox_override("panel", _create_panel_style())
	inner_panel.position = Vector2(30, 60)
	inner_panel.size = Vector2(panel_width, panel_height)
	rules_popup.add_child(inner_panel)
	
	var title = Label.new()
	title.name = "RulesTitle"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.position = Vector2(0, 15)
	title.size = Vector2(panel_width, 40)
	title.add_theme_font_size_override("font_size", 22)
	inner_panel.add_child(title)
	
	var scroll = ScrollContainer.new()
	scroll.position = Vector2(15, 65)
	scroll.size = Vector2(panel_width - 30, panel_height - 120)
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	inner_panel.add_child(scroll)
	
	var content = Label.new()
	content.name = "RulesContent"
	content.size = Vector2(panel_width - 50, 0)
	content.custom_minimum_size = Vector2(panel_width - 50, 0)
	content.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	content.add_theme_font_size_override("font_size", 15)
	scroll.add_child(content)
	
	rules_close_btn = Button.new()
	rules_close_btn.position = Vector2(panel_width / 2 - 80, panel_height - 55)
	rules_close_btn.size = Vector2(160, 45)
	rules_close_btn.add_theme_font_size_override("font_size", 18)
	rules_close_btn.add_theme_stylebox_override("normal", _create_button_style())
	rules_close_btn.add_theme_stylebox_override("hover", _create_button_hover_style())
	rules_close_btn.add_theme_stylebox_override("pressed", _create_button_hover_style())
	rules_close_btn.pressed.connect(func(): rules_popup.visible = false)
	inner_panel.add_child(rules_close_btn)
	
	add_child(rules_popup)

func _on_rules_pressed():
	_update_rules_content()
	rules_popup.visible = true
	rules_popup.move_to_front()

func _update_rules_content():
	# استخدام find_child عشان يدور على العقد باسمها مباشرة بدون مسارات معقدة
	var title_node = rules_popup.find_child("RulesTitle", true, false)
	var content_node = rules_popup.find_child("RulesContent", true, false)
	
	if current_lang == "ar":
		if title_node: title_node.text = "📜 قواعد اللعبة"
		if content_node: content_node.text = rules_text_ar
		if rules_close_btn: rules_close_btn.text = "إغلاق"
	else:
		if title_node: title_node.text = "📜 Game Rules"
		if content_node: content_node.text = rules_text_en
		if rules_close_btn: rules_close_btn.text = "Close"

func _get_card_texture(card_type: String) -> String:
	var lang_suffix = "_en" if current_lang == "en" else ""
	
	var paths_to_try = [
		"res://" + card_type + lang_suffix + ".jpg",
		"res://" + card_type + lang_suffix + ".png",
		"res://" + card_type + ".jpg",
		"res://" + card_type + ".png"
	]
	
	for path in paths_to_try:
		if ResourceLoader.exists(path):
			return path
	
	return "res://" + card_type + lang_suffix + ".jpg"

func _setup_chaos_label(screen_size):
	chaos_label = Label.new()
	chaos_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	chaos_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	chaos_label.position = Vector2(0, 150)
	chaos_label.size = Vector2(screen_size.x, 100)
	chaos_label.add_theme_font_size_override("font_size", 26)
	chaos_label.add_theme_color_override("font_color", Color(1, 0.2, 0.2, 1))
	chaos_label.add_theme_color_override("font_outline_color", Color(0, 0, 0, 1))
	chaos_label.add_theme_constant_override("outline_size", 8)
	chaos_label.visible = false
	gameplay_bg.add_child(chaos_label)

func _update_chaos_label():
	if chaos_turns_left > 0:
		chaos_label.text = _t("chaos_msg") % chaos_turns_left
		chaos_label.visible = true
	else:
		chaos_label.visible = false

func _reset_game():
	player_health = player_max_health
	ai_health = ai_max_health
	round_count = 1
	is_game_over = false
	current_turn = "player"
	chaos_turns_left = 0
	chaos_turns_remaining = 0
	last_devil_round = 0
	ai_played_this_round.clear()
	player_played_this_round.clear()
	light_popup_is_open = false
	eye_popup_is_open = false
	if light_popup: light_popup.visible = false
	if eye_popup: eye_popup.visible = false
	if chaos_label: chaos_label.visible = false
	
	player_hp_bar.value = player_health
	player_hp_bar.max_value = player_max_health
	player_hp_label.text = "❤️ صحتك: %d/%d" % [player_health, player_max_health]
	ai_hp_bar.value = ai_health
	ai_hp_bar.max_value = ai_max_health
	ai_hp_label.text = "❤️ صحة الخصم: %d/%d" % [ai_health, ai_max_health]
	
	game_over_panel.visible = false
	round_notification_label.visible = false
	
	for card in player_cards:
		if is_instance_valid(card): card.queue_free()
	for card in ai_cards:
		if is_instance_valid(card): card.queue_free()
	player_cards.clear()
	ai_cards.clear()
	
	var screen_size = get_viewport_rect().size
	_setup_ai_cards(screen_size, 0)
	_setup_player_cards(screen_size, 0)
	
	_start_player_turn()

func _setup_light_popup(screen_size):
	light_popup = Panel.new()
	light_popup.add_theme_stylebox_override("panel", _create_panel_style())
	light_popup.size = Vector2(300, 280)
	light_popup.position = Vector2(30, screen_size.y - 400)
	light_popup.visible = false
	gameplay_bg.add_child(light_popup)
	
	light_popup_title = Label.new()
	light_popup_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	light_popup_title.position = Vector2(0, 10)
	light_popup_title.size = Vector2(300, 30)
	light_popup_title.add_theme_font_size_override("font_size", 16)
	light_popup.add_child(light_popup_title)

func _setup_eye_popup(screen_size):
	eye_popup = Panel.new()
	eye_popup.add_theme_stylebox_override("panel", _create_panel_style())
	eye_popup.size = Vector2(300, 280)
	eye_popup.position = Vector2(30, screen_size.y - 400)
	eye_popup.visible = false
	gameplay_bg.add_child(eye_popup)
	
	eye_popup_title = Label.new()
	eye_popup_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	eye_popup_title.position = Vector2(0, 10)
	eye_popup_title.size = Vector2(300, 30)
	eye_popup_title.add_theme_font_size_override("font_size", 16)
	eye_popup.add_child(eye_popup_title)

func _show_light_popup(callback: Callable):
	if ai_played_this_round.size() == 0:
		_start_ai_turn()
		return
	light_popup_callback = callback
	light_popup_is_open = true
	light_popup_title.text = _t("light_title")
	for btn in light_popup_buttons:
		if is_instance_valid(btn): btn.queue_free()
	light_popup_buttons.clear()
	
	var y_pos = 50
	for card_type in ai_played_this_round:
		var btn = Button.new()
		btn.position = Vector2(20, y_pos)
		btn.size = Vector2(260, 35)
		btn.add_theme_font_size_override("font_size", 14)
		if card_type == "death": btn.text = _t("card_death")
		elif card_type == "again": btn.text = _t("card_again")
		elif card_type == "nothing": btn.text = _t("card_nothing")
		elif card_type == "light": btn.text = _t("card_light")
		elif card_type == "eye": btn.text = _t("card_eye")
		elif card_type == "spirit": btn.text = _t("card_spirit")
		elif card_type == "devil": btn.text = _t("card_devil")
		btn.add_theme_stylebox_override("normal", _create_button_style())
		btn.add_theme_stylebox_override("hover", _create_button_hover_style())
		btn.pressed.connect(_on_light_option_selected.bind(card_type))
		light_popup.add_child(btn)
		light_popup_buttons.append(btn)
		y_pos += 40
	
	light_popup.visible = true

func _on_light_option_selected(card_type: String):
	light_popup.visible = false
	light_popup_is_open = false
	if light_popup_callback.is_valid():
		light_popup_callback.call(card_type)

func _show_eye_popup():
	var available = []
	for card in player_cards:
		if not card.get_meta("is_played"):
			available.append(card)
	if available.size() == 0:
		_start_ai_turn()
		return
	eye_popup_is_open = true
	eye_popup_title.text = _t("eye_title")
	for btn in eye_popup_buttons:
		if is_instance_valid(btn): btn.queue_free()
	eye_popup_buttons.clear()
	
	var y_pos = 50
	var idx = 1
	for card in available:
		var btn = Button.new()
		btn.position = Vector2(20, y_pos)
		btn.size = Vector2(260, 35)
		btn.add_theme_font_size_override("font_size", 14)
		btn.text = _t("eye_button") % idx
		btn.add_theme_stylebox_override("normal", _create_button_style())
		btn.add_theme_stylebox_override("hover", _create_button_hover_style())
		btn.pressed.connect(_on_eye_option_selected.bind(card))
		eye_popup.add_child(btn)
		eye_popup_buttons.append(btn)
		y_pos += 40
		idx += 1
	
	eye_popup.visible = true

func _on_eye_option_selected(card):
	eye_popup.visible = false
	eye_popup_is_open = false
	await get_tree().create_timer(0.5).timeout
	var type = card.get_meta("card_type")
	var tex_path = _get_card_texture(type)
	if ResourceLoader.exists(tex_path):
		card.texture_normal = load(tex_path)
	card.set_meta("is_revealed", true)
	await get_tree().create_timer(10.0).timeout
	if is_instance_valid(card) and not card.get_meta("is_played"):
		if ResourceLoader.exists("res://card_back.png"):
			card.texture_normal = load("res://card_back.png")
		card.set_meta("is_revealed", false)
	if not is_game_over:
		_start_ai_turn()

func _apply_card_effect_to_player(card_type: String):
	if card_type == "death":
		_lose_health(50)
		if not is_game_over: _start_new_round()
	elif card_type == "spirit":
		_heal_player(50)

func _apply_card_effect_to_ai(card_type: String):
	if card_type == "death":
		_lose_ai_health(50)
		if not is_game_over: _start_new_round()
	elif card_type == "spirit":
		_heal_ai(50)

func _heal_player(amount: int):
	player_health += amount
	player_max_health = max(player_max_health, player_health)
	player_hp_bar.max_value = player_max_health
	player_hp_bar.value = player_health
	player_hp_label.text = "❤️ صحتك: %d/%d" % [player_health, player_max_health]

func _heal_ai(amount: int):
	ai_health += amount
	ai_max_health = max(ai_max_health, ai_health)
	ai_hp_bar.max_value = ai_max_health
	ai_hp_bar.value = ai_health
	ai_hp_label.text = "❤️ صحة الخصم: %d/%d" % [ai_health, ai_max_health]

func _setup_round_notification(screen_size):
	round_notification_label = Label.new()
	round_notification_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	round_notification_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	round_notification_label.position = Vector2(0, screen_size.y / 2 - 60)
	round_notification_label.size = Vector2(screen_size.x, 120)
	round_notification_label.add_theme_font_size_override("font_size", 32)
	round_notification_label.add_theme_color_override("font_color", Color(1, 1, 0.5, 1))
	round_notification_label.add_theme_color_override("font_outline_color", Color(0, 0, 0, 1))
	round_notification_label.add_theme_constant_override("outline_size", 8)
	round_notification_label.visible = false
	gameplay_bg.add_child(round_notification_label)

func _setup_game_over_panel(screen_size):
	game_over_panel = Panel.new()
	game_over_panel.size = screen_size
	game_over_panel.visible = false
	game_over_panel.add_theme_stylebox_override("panel", StyleBoxEmpty.new())
	
	var panel_width = 400.0
	var panel_height = 280.0
	var inner_panel = Panel.new()
	inner_panel.add_theme_stylebox_override("panel", _create_panel_style())
	inner_panel.position = Vector2(30, screen_size.y / 2 - 140)
	inner_panel.size = Vector2(panel_width, panel_height)
	game_over_panel.add_child(inner_panel)
	
	result_label = Label.new()
	result_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	result_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	result_label.position = Vector2(0, 20)
	result_label.size = Vector2(panel_width, 60)
	result_label.add_theme_font_size_override("font_size", 26)
	inner_panel.add_child(result_label)
	
	play_again_btn = Button.new()
	play_again_btn.position = Vector2(panel_width / 2 - 120, 100)
	play_again_btn.size = Vector2(240, 55)
	play_again_btn.add_theme_font_size_override("font_size", 18)
	play_again_btn.add_theme_stylebox_override("normal", _create_button_style())
	play_again_btn.add_theme_stylebox_override("hover", _create_button_hover_style())
	play_again_btn.add_theme_stylebox_override("pressed", _create_button_hover_style())
	play_again_btn.add_theme_stylebox_override("focus", _create_button_style())
	play_again_btn.pressed.connect(_on_play_again_pressed)
	inner_panel.add_child(play_again_btn)
	
	exit_game_over_btn = Button.new()
	exit_game_over_btn.position = Vector2(panel_width / 2 - 120, 175)
	exit_game_over_btn.size = Vector2(240, 55)
	exit_game_over_btn.add_theme_font_size_override("font_size", 18)
	exit_game_over_btn.add_theme_stylebox_override("normal", _create_button_style())
	exit_game_over_btn.add_theme_stylebox_override("hover", _create_button_hover_style())
	exit_game_over_btn.add_theme_stylebox_override("pressed", _create_button_hover_style())
	exit_game_over_btn.add_theme_stylebox_override("focus", _create_button_style())
	exit_game_over_btn.pressed.connect(_on_exit_game_over_pressed)
	inner_panel.add_child(exit_game_over_btn)
	
	gameplay_bg.add_child(game_over_panel)

func _create_button_style() -> StyleBoxFlat:
	var style = StyleBoxFlat.new()
	style.bg_color = Color(0.25, 0.13, 0.38, 1.0)
	style.corner_radius_top_left = 10
	style.corner_radius_top_right = 10
	style.corner_radius_bottom_left = 10
	style.corner_radius_bottom_right = 10
	style.border_width_top = 2
	style.border_width_bottom = 2
	style.border_width_left = 2
	style.border_width_right = 2
	style.border_color = Color(0.7, 0.45, 0.95, 1.0)
	style.content_margin_left = 10
	style.content_margin_right = 10
	style.content_margin_top = 5
	style.content_margin_bottom = 5
	return style

func _create_button_hover_style() -> StyleBoxFlat:
	var style = StyleBoxFlat.new()
	style.bg_color = Color(0.4, 0.2, 0.6, 1.0)
	style.corner_radius_top_left = 10
	style.corner_radius_top_right = 10
	style.corner_radius_bottom_left = 10
	style.corner_radius_bottom_right = 10
	style.border_width_top = 2
	style.border_width_bottom = 2
	style.border_width_left = 2
	style.border_width_right = 2
	style.border_color = Color(0.85, 0.6, 1.0, 1.0)
	style.content_margin_left = 10
	style.content_margin_right = 10
	style.content_margin_top = 5
	style.content_margin_bottom = 5
	return style

func _setup_health_bars(screen_size):
	var bar_width = 300
	var bar_height = 30
	var bar_x = 30
	var bar_y = screen_size.y - 100
	player_hp_label = Label.new()
	player_hp_label.position = Vector2(bar_x, bar_y - 30)
	player_hp_label.size = Vector2(bar_width, 30)
	player_hp_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	player_hp_label.add_theme_font_size_override("font_size", 18)
	player_hp_label.text = "❤️ صحتك: %d/%d" % [player_health, player_max_health]
	gameplay_bg.add_child(player_hp_label)
	player_hp_bar = ProgressBar.new()
	player_hp_bar.position = Vector2(bar_x, bar_y)
	player_hp_bar.size = Vector2(bar_width, bar_height)
	player_hp_bar.max_value = player_max_health
	player_hp_bar.value = player_health
	player_hp_bar.show_percentage = false
	gameplay_bg.add_child(player_hp_bar)
	ai_hp_label = Label.new()
	ai_hp_label.position = Vector2(30, 70)
	ai_hp_label.size = Vector2(200, 30)
	ai_hp_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	ai_hp_label.add_theme_font_size_override("font_size", 18)
	ai_hp_label.text = "❤️ صحة الخصم: %d/%d" % [ai_health, ai_max_health]
	gameplay_bg.add_child(ai_hp_label)
	ai_hp_bar = ProgressBar.new()
	ai_hp_bar.position = Vector2(30, 95)
	ai_hp_bar.size = Vector2(200, 20)
	ai_hp_bar.max_value = ai_max_health
	ai_hp_bar.value = ai_health
	ai_hp_bar.show_percentage = false
	gameplay_bg.add_child(ai_hp_bar)

func _setup_language_button():
	lang_btn = Button.new()
	lang_btn.name = "LangButton"
	lang_btn.text = "🌐 EN"
	lang_btn.position = Vector2(30, 30)
	lang_btn.size = Vector2(110, 55)
	lang_btn.add_theme_font_size_override("font_size", 20)
	lang_btn.pressed.connect(_on_language_pressed)
	add_child(lang_btn)

func _on_language_pressed():
	if current_lang == "ar":
		current_lang = "en"
		lang_btn.text = "🌐 ع"
	else:
		current_lang = "ar"
		lang_btn.text = "🌐 EN"
	_update_all_texts()

func _t(key: String) -> String:
	return texts[current_lang].get(key, key)

func _update_all_texts():
	play_btn.text = _t("play")
	profile_btn.text = ("" if current_avatar_texture else "👤 ") + my_username
	mode_title_label.text = _t("choose_mode")
	ai_btn.text = _t("vs_ai")
	create_room_btn.text = _t("create_room")
	join_room_btn.text = _t("join_room")
	modes_close_btn.text = _t("close")
	cr_title.text = _t("create_room_title")
	cr_code_lbl.text = _t("room_code")
	cr_start_btn.text = _t("start_game")
	cr_back_btn.text = _t("back")
	jr_title.text = _t("join_room_title")
	jr_code_input.placeholder_text = _t("room_code_placeholder")
	jr_enter_btn.text = _t("enter_room")
	jr_back_btn.text = _t("back")
	diff_title.text = _t("difficulty_title")
	easy_btn.text = _t("easy")
	medium_btn.text = _t("medium")
	hard_btn.text = _t("hard")
	diff_back_btn.text = _t("back")
	pc_title.text = _t("player_count_title")
	pc_one_btn.text = _t("one_vs_one")
	pc_back_btn.text = _t("back")
	p_title.text = _t("profile_title")
	if current_avatar_texture == null: avatar_btn.text = _t("change_avatar")
	p_id_lbl.text = _t("your_id") + my_player_id
	p_name_lbl.text = _t("change_name")
	p_close_btn.text = _t("close")
	f_title.text = _t("add_friend_title")
	friend_input.placeholder_text = _t("friend_placeholder")
	f_search_btn.text = _t("search_add")
	f_close_btn.text = _t("close")
	_update_friends_ui()
	ai_label_ref.text = _t("ai_cards")
	player_label_ref.text = _t("your_cards")
	play_again_btn.text = _t("play_again")
	exit_game_over_btn.text = _t("quit")
	_update_chaos_label()
	_update_rules_content()

func _hide_all_popups():
	if modes_panel: modes_panel.visible = false
	if difficulty_panel: difficulty_panel.visible = false
	if player_count_panel: player_count_panel.visible = false
	if room_create_panel: room_create_panel.visible = false
	if room_join_panel: room_join_panel.visible = false
	if profile_popup: profile_popup.visible = false
	if friends_popup: friends_popup.visible = false
	if rules_popup: rules_popup.visible = false

func _on_play_pressed():
	_hide_all_popups()
	modes_panel.visible = true

func _setup_gameplay_background(screen_size):
	gameplay_bg = Control.new()
	gameplay_bg.size = screen_size
	gameplay_bg.visible = false
	
	var black_bg = ColorRect.new()
	black_bg.color = Color(0, 0, 0, 1)
	black_bg.size = screen_size
	black_bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	gameplay_bg.add_child(black_bg)
	
	var table_bg = TextureRect.new()
	if ResourceLoader.exists("res://table_bg.png"):
		table_bg.texture = load("res://table_bg.png")
	table_bg.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	table_bg.stretch_mode = TextureRect.STRETCH_SCALE
	table_bg.position = Vector2.ZERO
	table_bg.size = screen_size
	table_bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	gameplay_bg.add_child(table_bg)

	ai_label_ref = Label.new()
	ai_label_ref.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	ai_label_ref.position = Vector2(0, 15)
	ai_label_ref.size = Vector2(screen_size.x, 30)
	gameplay_bg.add_child(ai_label_ref)
	player_label_ref = Label.new()
	player_label_ref.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	player_label_ref.position = Vector2(0, screen_size.y - 175)
	player_label_ref.size = Vector2(screen_size.x, 30)
	gameplay_bg.add_child(player_label_ref)
	
	add_child(gameplay_bg)

func _setup_ai_cards(screen_size, margin):
	var card_width = 105
	var card_height = 155
	var total_cards = 7
	var spacing = 6
	var total_width = (total_cards * card_width) + ((total_cards - 1) * spacing)
	var start_x = (screen_size.x - total_width) / 2
	var start_y = 70
	var card_types = ["again", "death", "nothing", "light", "eye", "spirit", "devil"]
	card_types.shuffle()
	for i in range(total_cards):
		var ai_card = TextureButton.new()
		ai_card.size = Vector2(card_width, card_height)
		ai_card.position = Vector2(start_x + (i * (card_width + spacing)), start_y)
		ai_card.ignore_texture_size = true
		ai_card.stretch_mode = TextureButton.STRETCH_SCALE
		if ResourceLoader.exists("res://card_back.png"): ai_card.texture_normal = load("res://card_back.png")
		ai_card.set_meta("card_type", card_types[i])
		ai_card.set_meta("is_played", false)
		ai_card.set_meta("is_revealed", false)
		ai_card.disabled = true
		ai_card.pressed.connect(_on_ai_card_clicked.bind(ai_card))
		ai_cards.append(ai_card)
		gameplay_bg.add_child(ai_card)

func _setup_player_cards(screen_size, margin):
	var card_width = 105
	var card_height = 155
	var total_cards = 7
	var spacing = 6
	var total_width = (total_cards * card_width) + ((total_cards - 1) * spacing)
	var start_x = screen_size.x - total_width - 30
	var start_y = screen_size.y - card_height - 30
	var card_types = ["again", "death", "nothing", "light", "eye", "spirit", "devil"]
	card_types.shuffle()
	for i in range(total_cards):
		var card_btn = TextureButton.new()
		card_btn.size = Vector2(card_width, card_height)
		card_btn.position = Vector2(start_x + (i * (card_width + spacing)), start_y)
		card_btn.ignore_texture_size = true
		card_btn.stretch_mode = TextureButton.STRETCH_SCALE
		if ResourceLoader.exists("res://card_back.png"): card_btn.texture_normal = load("res://card_back.png")
		card_btn.set_meta("card_type", card_types[i])
		card_btn.set_meta("is_played", false)
		card_btn.set_meta("is_revealed", false)
		card_btn.pressed.connect(_on_player_card_clicked.bind(card_btn))
		player_cards.append(card_btn)
		gameplay_bg.add_child(card_btn)
	_start_player_turn()

func _on_player_card_clicked(card_btn: TextureButton):
	if is_game_over or current_turn != "player" or light_popup_is_open or eye_popup_is_open: return
	if chaos_turns_left > 0: return
	if card_btn.get_meta("is_played") == true: return
	
	for card in player_cards:
		card.disabled = true
	for card in ai_cards:
		card.disabled = true
	
	card_btn.set_meta("is_played", true)
	card_btn.set_meta("is_revealed", true)
	var card_type = card_btn.get_meta("card_type")
	player_played_this_round.append(card_type)
	if ResourceLoader.exists(_get_card_texture(card_type)): card_btn.texture_normal = load(_get_card_texture(card_type))
	await get_tree().create_timer(1.5).timeout
	if is_game_over: return
	if ResourceLoader.exists("res://card_back.png"): card_btn.texture_normal = load("res://card_back.png")
	card_btn.modulate = Color(0.5, 0.5, 0.5, 1)
	await get_tree().create_timer(0.3).timeout
	_shuffle_remaining_cards(player_cards)
	if is_game_over: return
	
	if card_type == "again":
		_start_player_turn()
	elif card_type == "death":
		_lose_health(50)
		if not is_game_over: _start_new_round()
	elif card_type == "light":
		_show_light_popup(_on_player_light_done)
	elif card_type == "eye":
		_show_eye_popup()
	elif card_type == "spirit":
		_heal_player(50)
		_start_ai_turn()
	elif card_type == "devil":
		chaos_turns_left = 1
		chaos_turns_remaining = 1
		last_devil_round = round_count
		_update_chaos_label()
		_start_ai_turn()
	else:
		_start_ai_turn()

func _on_player_light_done(card_type: String):
	_apply_card_effect_to_player(card_type)
	if not is_game_over:
		await get_tree().create_timer(0.5).timeout
		_start_ai_turn()

func _ai_choose_card_type() -> String:
	var available = []
	for card in ai_cards:
		if not card.get_meta("is_played"):
			available.append(card.get_meta("card_type"))
	
	if available.size() == 0:
		return ""
	
	if current_difficulty == "easy":
		return available[randi() % available.size()]
	
	var priority = []
	if ai_health < 100 and "spirit" in available:
		priority.append("spirit")
	if "eye" in available:
		priority.append("eye")
	if "spirit" in available and not "spirit" in priority:
		priority.append("spirit")
	if "nothing" in available:
		priority.append("nothing")
	if "again" in available:
		priority.append("again")
	if "light" in available:
		priority.append("light")
	if "death" in available:
		priority.append("death")
	
	for p in priority:
		if p in available:
			return p
	return available[0]

func _ai_choose_light_card() -> String:
	if player_played_this_round.size() == 0:
		return ""
	
	if current_difficulty == "easy":
		return player_played_this_round[randi() % player_played_this_round.size()]
	
	var priority = ["spirit", "eye", "again", "nothing", "light", "death"]
	for p in priority:
		if p in player_played_this_round:
			return p
	return player_played_this_round[0]

func _ai_choose_player_card_smart() -> String:
	var available = []
	for card in player_cards:
		if not card.get_meta("is_played"):
			available.append(card.get_meta("card_type"))
	if available.size() == 0:
		return ""
	
	var priority = []
	if player_health <= 50 and "death" in available:
		priority.append("death")
	if "death" in available and not "death" in priority:
		priority.append("death")
	if "again" in available:
		priority.append("again")
	if "light" in available:
		priority.append("light")
	if "nothing" in available:
		priority.append("nothing")
	if "eye" in available:
		priority.append("eye")
	if "spirit" in available:
		priority.append("spirit")
	
	for p in priority:
		if p in available:
			return p
	return available[0]

func _ai_chaos_pick_light() -> String:
	var priority = ["death", "again", "nothing", "eye", "light", "spirit"]
	for p in priority:
		if p in ai_played_this_round:
			return p
	return ""

func _chaos_auto_play():
	if is_game_over: return
	var chosen_type = _ai_choose_player_card_smart()
	
	if chosen_type == "":
		chaos_turns_left = 0
		_update_chaos_label()
		_start_ai_turn()
		return
	
	for card in player_cards:
		if not card.get_meta("is_played") and card.get_meta("card_type") == chosen_type:
			for c in player_cards:
				c.disabled = true
			for c in ai_cards:
				c.disabled = true
			
			card.set_meta("is_played", true)
			card.set_meta("is_revealed", true)
			player_played_this_round.append(chosen_type)
			if ResourceLoader.exists(_get_card_texture(chosen_type)): card.texture_normal = load(_get_card_texture(chosen_type))
			await get_tree().create_timer(1.5).timeout
			if is_game_over: return
			if ResourceLoader.exists("res://card_back.png"): card.texture_normal = load("res://card_back.png")
			card.modulate = Color(0.5, 0.5, 0.5, 1)
			await get_tree().create_timer(0.3).timeout
			_shuffle_remaining_cards(player_cards)
			if is_game_over: return
			
			if chosen_type == "again":
				_start_player_turn(true)
			elif chosen_type == "death":
				_lose_health(50)
				if not is_game_over: _start_new_round()
			elif chosen_type == "light":
				var picked = _ai_chaos_pick_light()
				if picked != "":
					_apply_card_effect_to_player(picked)
				if not is_game_over: _start_ai_turn()
			elif chosen_type == "eye":
				_start_ai_turn()
			elif chosen_type == "spirit":
				_heal_player(50)
				_start_ai_turn()
			else:
				_start_ai_turn()
			return

func _on_ai_card_clicked(card_btn: TextureButton):
	if is_game_over: return
	if card_btn.get_meta("is_played") == true: return
	
	for card in player_cards:
		card.disabled = true
	for card in ai_cards:
		card.disabled = true
	
	card_btn.set_meta("is_played", true)
	card_btn.set_meta("is_revealed", true)
	var card_type = card_btn.get_meta("card_type")
	ai_played_this_round.append(card_type)
	if ResourceLoader.exists(_get_card_texture(card_type)): card_btn.texture_normal = load(_get_card_texture(card_type))
	await get_tree().create_timer(1.5).timeout
	if is_game_over: return
	if ResourceLoader.exists("res://card_back.png"): card_btn.texture_normal = load("res://card_back.png")
	card_btn.modulate = Color(0.5, 0.5, 0.5, 1)
	await get_tree().create_timer(0.3).timeout
	_shuffle_remaining_cards(ai_cards)
	if is_game_over: return
	
	if card_type == "again":
		_start_ai_turn()
	elif card_type == "death":
		_lose_ai_health(50)
		if not is_game_over: _start_new_round()
	elif card_type == "light":
		var picked = _ai_choose_light_card()
		if picked != "":
			_apply_card_effect_to_ai(picked)
		if not is_game_over: _start_player_turn()
	elif card_type == "eye":
		_start_player_turn()
	elif card_type == "spirit":
		_heal_ai(50)
		_start_player_turn()
	elif card_type == "devil":
		_start_player_turn()
	else:
		_start_player_turn()

func _shuffle_remaining_cards(cards):
	var unplayed = []
	for card in cards:
		if not card.get_meta("is_played"): unplayed.append(card)
	if unplayed.size() <= 1: return
	var positions = []
	for card in unplayed: positions.append(card.position)
	positions.shuffle()
	for i in range(unplayed.size()): unplayed[i].position = positions[i]

func _start_player_turn(skip_decrement: bool = false):
	if is_game_over: return
	current_turn = "player"
	
	if chaos_turns_left > 0:
		if not skip_decrement:
			chaos_turns_left -= 1
		_update_chaos_label()
		for card in player_cards:
			card.disabled = true
		for card in ai_cards:
			card.disabled = true
		await get_tree().create_timer(1.5).timeout
		if is_game_over: return
		_chaos_auto_play()
		return
	
	for card in player_cards:
		if not card.get_meta("is_played"): card.disabled = false
	for card in ai_cards: card.disabled = true

func _start_ai_turn():
	if is_game_over: return
	current_turn = "ai"
	for card in player_cards: card.disabled = true
	for card in ai_cards:
		if not card.get_meta("is_played"): card.disabled = false
	await get_tree().create_timer(1.0).timeout
	if is_game_over: return
	_ai_choose_card()

func _ai_choose_card():
	if is_game_over: return
	var chosen_type = _ai_choose_card_type()
	if chosen_type == "":
		_start_new_round()
		return
	for card in ai_cards:
		if not card.get_meta("is_played") and card.get_meta("card_type") == chosen_type:
			_on_ai_card_clicked(card)
			return
	_start_new_round()

func _start_new_round():
	round_count += 1
	round_notification_label.text = _t("round_end") % [round_count - 1, round_count]
	round_notification_label.visible = true
	await get_tree().create_timer(2.5).timeout
	round_notification_label.visible = false
	for card in player_cards: card.queue_free()
	for card in ai_cards: card.queue_free()
	player_cards.clear()
	ai_cards.clear()
	ai_played_this_round.clear()
	player_played_this_round.clear()
	light_popup_is_open = false
	eye_popup_is_open = false
	if light_popup: light_popup.visible = false
	if eye_popup: eye_popup.visible = false
	var screen_size = get_viewport_rect().size
	_setup_ai_cards(screen_size, 0)
	_setup_player_cards(screen_size, 0)
	is_game_over = false
	game_over_panel.visible = false
	_start_player_turn()

func _lose_health(amount: int):
	if is_game_over: return
	player_health = max(0, player_health - amount)
	player_hp_bar.value = player_health
	player_hp_label.text = "❤️ صحتك: %d/%d" % [player_health, player_max_health]
	if player_health <= 0:
		is_game_over = true
		result_label.text = _t("you_lose")
		game_over_panel.visible = true
		chaos_turns_left = 0
		_update_chaos_label()
		for card in player_cards: card.disabled = true
		for card in ai_cards: card.disabled = true

func _lose_ai_health(amount: int):
	if is_game_over: return
	ai_health = max(0, ai_health - amount)
	ai_hp_bar.value = ai_health
	ai_hp_label.text = "❤️ صحة الخصم: %d/%d" % [ai_health, ai_max_health]
	if ai_health <= 0:
		is_game_over = true
		result_label.text = _t("you_win")
		game_over_panel.visible = true
		chaos_turns_left = 0
		_update_chaos_label()
		for card in player_cards: card.disabled = true
		for card in ai_cards: card.disabled = true

func _on_play_again_pressed():
	_reset_game()

func _on_exit_game_over_pressed():
	game_over_panel.visible = false
	gameplay_bg.visible = false
	round_notification_label.visible = false
	chaos_turns_left = 0
	if chaos_label: chaos_label.visible = false
	if main_bg: main_bg.visible = true
	if play_btn: play_btn.visible = true
	if profile_btn: profile_btn.visible = true
	if lang_btn: lang_btn.visible = true
	if add_friend_btn: add_friend_btn.visible = true
	if rules_btn: rules_btn.visible = true
	_reset_game()

func _setup_modes_panel(screen_size):
	modes_panel = Panel.new()
	modes_panel.add_theme_stylebox_override("panel", _create_panel_style())
	modes_panel.position = Vector2(screen_size.x / 2 - 200, screen_size.y / 2 - 220)
	modes_panel.size = Vector2(400, 360)
	modes_panel.visible = false
	add_child(modes_panel)
	mode_title_label = Label.new()
	mode_title_label.position = Vector2(130, 20)
	modes_panel.add_child(mode_title_label)
	ai_btn = Button.new()
	ai_btn.position = Vector2(50, 70)
	ai_btn.size = Vector2(300, 50)
	ai_btn.pressed.connect(func():
		_hide_all_popups()
		difficulty_panel.visible = true)
	modes_panel.add_child(ai_btn)
	create_room_btn = Button.new()
	create_room_btn.position = Vector2(50, 140)
	create_room_btn.size = Vector2(300, 50)
	create_room_btn.pressed.connect(func():
		_hide_all_popups()
		room_create_panel.visible = true)
	modes_panel.add_child(create_room_btn)
	join_room_btn = Button.new()
	join_room_btn.position = Vector2(50, 210)
	join_room_btn.size = Vector2(300, 50)
	join_room_btn.pressed.connect(func():
		_hide_all_popups()
		room_join_panel.visible = true)
	modes_panel.add_child(join_room_btn)
	modes_close_btn = Button.new()
	modes_close_btn.position = Vector2(350, 10)
	modes_close_btn.size = Vector2(40, 40)
	modes_close_btn.pressed.connect(func(): modes_panel.visible = false)
	modes_panel.add_child(modes_close_btn)

func _setup_room_create_panel(screen_size):
	room_create_panel = Panel.new()
	room_create_panel.add_theme_stylebox_override("panel", _create_panel_style())
	room_create_panel.position = Vector2(screen_size.x / 2 - 200, screen_size.y / 2 - 150)
	room_create_panel.size = Vector2(400, 260)
	room_create_panel.visible = false
	add_child(room_create_panel)
	cr_title = Label.new()
	cr_title.position = Vector2(130, 20)
	room_create_panel.add_child(cr_title)
	cr_code_lbl = Label.new()
	cr_code_lbl.position = Vector2(80, 80)
	cr_code_lbl.size = Vector2(250, 30)
	room_create_panel.add_child(cr_code_lbl)
	cr_start_btn = Button.new()
	cr_start_btn.position = Vector2(100, 140)
	cr_start_btn.size = Vector2(200, 45)
	cr_start_btn.pressed.connect(func():
		_hide_all_popups()
		_show_gameplay())
	room_create_panel.add_child(cr_start_btn)
	cr_back_btn = Button.new()
	cr_back_btn.position = Vector2(150, 200)
	cr_back_btn.size = Vector2(100, 35)
	cr_back_btn.pressed.connect(func():
		_hide_all_popups()
		modes_panel.visible = true)
	room_create_panel.add_child(cr_back_btn)

func _setup_room_join_panel(screen_size):
	room_join_panel = Panel.new()
	room_join_panel.add_theme_stylebox_override("panel", _create_panel_style())
	room_join_panel.position = Vector2(screen_size.x / 2 - 200, screen_size.y / 2 - 160)
	room_join_panel.size = Vector2(400, 280)
	room_join_panel.visible = false
	add_child(room_join_panel)
	jr_title = Label.new()
	jr_title.position = Vector2(130, 20)
	room_join_panel.add_child(jr_title)
	jr_code_input = LineEdit.new()
	jr_code_input.position = Vector2(50, 80)
	jr_code_input.size = Vector2(300, 45)
	room_join_panel.add_child(jr_code_input)
	jr_enter_btn = Button.new()
	jr_enter_btn.position = Vector2(100, 145)
	jr_enter_btn.size = Vector2(200, 45)
	jr_enter_btn.pressed.connect(func():
		_hide_all_popups()
		_show_gameplay())
	room_join_panel.add_child(jr_enter_btn)
	jr_back_btn = Button.new()
	jr_back_btn.position = Vector2(150, 210)
	jr_back_btn.size = Vector2(100, 35)
	jr_back_btn.pressed.connect(func():
		_hide_all_popups()
		modes_panel.visible = true)
	room_join_panel.add_child(jr_back_btn)

func _setup_difficulty_panel(screen_size):
	difficulty_panel = Panel.new()
	difficulty_panel.add_theme_stylebox_override("panel", _create_panel_style())
	difficulty_panel.position = Vector2(screen_size.x / 2 - 200, screen_size.y / 2 - 180)
	difficulty_panel.size = Vector2(400, 320)
	difficulty_panel.visible = false
	add_child(difficulty_panel)
	diff_title = Label.new()
	diff_title.position = Vector2(110, 20)
	difficulty_panel.add_child(diff_title)
	easy_btn = Button.new()
	easy_btn.position = Vector2(50, 70)
	easy_btn.size = Vector2(300, 45)
	easy_btn.pressed.connect(func():
		current_difficulty = "easy"
		_hide_all_popups()
		player_count_panel.visible = true)
	difficulty_panel.add_child(easy_btn)
	medium_btn = Button.new()
	medium_btn.position = Vector2(50, 130)
	medium_btn.size = Vector2(300, 45)
	medium_btn.pressed.connect(func():
		current_difficulty = "medium"
		_hide_all_popups()
		player_count_panel.visible = true)
	difficulty_panel.add_child(medium_btn)
	hard_btn = Button.new()
	hard_btn.position = Vector2(50, 190)
	hard_btn.size = Vector2(300, 45)
	hard_btn.pressed.connect(func():
		current_difficulty = "hard"
		_hide_all_popups()
		player_count_panel.visible = true)
	difficulty_panel.add_child(hard_btn)
	diff_back_btn = Button.new()
	diff_back_btn.position = Vector2(150, 260)
	diff_back_btn.size = Vector2(100, 40)
	diff_back_btn.pressed.connect(func():
		_hide_all_popups()
		modes_panel.visible = true)
	difficulty_panel.add_child(diff_back_btn)

func _setup_player_count_panel(screen_size):
	player_count_panel = Panel.new()
	player_count_panel.add_theme_stylebox_override("panel", _create_panel_style())
	player_count_panel.position = Vector2(screen_size.x / 2 - 200, screen_size.y / 2 - 150)
	player_count_panel.size = Vector2(400, 250)
	player_count_panel.visible = false
	add_child(player_count_panel)
	pc_title = Label.new()
	pc_title.position = Vector2(120, 20)
	player_count_panel.add_child(pc_title)
	pc_one_btn = Button.new()
	pc_one_btn.position = Vector2(50, 70)
	pc_one_btn.size = Vector2(300, 50)
	pc_one_btn.pressed.connect(func():
		_hide_all_popups()
		_show_gameplay())
	player_count_panel.add_child(pc_one_btn)
	pc_back_btn = Button.new()
	pc_back_btn.position = Vector2(150, 150)
	pc_back_btn.size = Vector2(100, 40)
	pc_back_btn.pressed.connect(func():
		_hide_all_popups()
		difficulty_panel.visible = true)
	player_count_panel.add_child(pc_back_btn)

func _show_gameplay():
	_reset_game()
	if main_bg: main_bg.visible = false
	if play_btn: play_btn.visible = false
	if profile_btn: profile_btn.visible = false
	if lang_btn: lang_btn.visible = false
	if add_friend_btn: add_friend_btn.visible = false
	if rules_btn: rules_btn.visible = false
	if gameplay_bg: gameplay_bg.visible = true

func _create_panel_style() -> StyleBoxFlat:
	var style = StyleBoxFlat.new()
	style.bg_color = Color(0.1, 0.1, 0.12, 0.98)
	style.corner_radius_top_left = 12
	style.corner_radius_top_right = 12
	style.corner_radius_bottom_left = 12
	style.corner_radius_bottom_right = 12
	return style

func _setup_profile_popup(screen_size):
	profile_popup = Panel.new()
	profile_popup.add_theme_stylebox_override("panel", _create_panel_style())
	profile_popup.position = Vector2(screen_size.x / 2 - 200, screen_size.y / 2 - 210)
	profile_popup.size = Vector2(400, 420)
	profile_popup.visible = false
	add_child(profile_popup)
	p_title = Label.new()
	p_title.position = Vector2(150, 20)
	profile_popup.add_child(p_title)
	avatar_btn = Button.new()
	avatar_btn.position = Vector2(140, 60)
	avatar_btn.size = Vector2(120, 100)
	avatar_btn.pressed.connect(_open_gallery)
	profile_popup.add_child(avatar_btn)
	p_id_lbl = Label.new()
	p_id_lbl.position = Vector2(50, 175)
	p_id_lbl.size = Vector2(300, 30)
	profile_popup.add_child(p_id_lbl)
	p_name_lbl = Label.new()
	p_name_lbl.position = Vector2(50, 215)
	profile_popup.add_child(p_name_lbl)
	var name_edit = LineEdit.new()
	name_edit.text = my_username
	name_edit.position = Vector2(50, 245)
	name_edit.size = Vector2(300, 45)
	name_edit.text_changed.connect(_on_username_updated)
	profile_popup.add_child(name_edit)
	p_close_btn = Button.new()
	p_close_btn.position = Vector2(350, 10)
	p_close_btn.size = Vector2(40, 40)
	p_close_btn.pressed.connect(func(): profile_popup.visible = false)
	profile_popup.add_child(p_close_btn)

func _setup_friends_popup(screen_size):
	friends_popup = Panel.new()
	friends_popup.add_theme_stylebox_override("panel", _create_panel_style())
	friends_popup.position = Vector2(screen_size.x / 2 - 200, screen_size.y / 2 - 180)
	friends_popup.size = Vector2(400, 360)
	friends_popup.visible = false
	add_child(friends_popup)
	f_title = Label.new()
	f_title.position = Vector2(160, 15)
	friends_popup.add_child(f_title)
	friend_input = LineEdit.new()
	friend_input.position = Vector2(30, 50)
	friend_input.size = Vector2(340, 45)
	friends_popup.add_child(friend_input)
	f_search_btn = Button.new()
	f_search_btn.position = Vector2(120, 105)
	f_search_btn.size = Vector2(160, 40)
	f_search_btn.pressed.connect(_on_search_and_add_clicked)
	friends_popup.add_child(f_search_btn)
	status_label = Label.new()
	status_label.position = Vector2(30, 155)
	status_label.size = Vector2(340, 30)
	friends_popup.add_child(status_label)
	friends_list_label = Label.new()
	friends_list_label.position = Vector2(30, 195)
	friends_popup.add_child(friends_list_label)
	f_close_btn = Button.new()
	f_close_btn.position = Vector2(350, 10)
	f_close_btn.size = Vector2(40, 40)
	f_close_btn.pressed.connect(func(): friends_popup.visible = false)
	friends_popup.add_child(f_close_btn)

func _init_android_gallery_plugin():
	if Engine.has_singleton("GodotGetImage"):
		android_image_plugin = Engine.get_singleton("GodotGetImage")
		android_image_plugin.connect("image_request_completed", _on_android_image_picked)

func _open_gallery():
	if OS.get_name() == "Android" and android_image_plugin != null:
		if android_image_plugin.has_method("getGalleryImage"): android_image_plugin.getGalleryImage()
	else: file_dialog.popup_centered()

func _on_android_image_picked(dict):
	if dict.has("buffer"):
		var img = Image.new()
		img.load_jpg_from_buffer(dict["buffer"])
		if img.is_empty(): img.load_png_from_buffer(dict["buffer"])
		_apply_profile_image(img)

func _apply_profile_image(image: Image):
	current_avatar_texture = ImageTexture.create_from_image(image)
	avatar_btn.icon = current_avatar_texture
	avatar_btn.expand_icon = true
	avatar_btn.text = ""
	profile_btn.icon = current_avatar_texture
	profile_btn.expand_icon = true
	profile_btn.text = " " + my_username

func _setup_file_dialog():
	file_dialog = FileDialog.new()
	file_dialog.file_mode = FileDialog.FILE_MODE_OPEN_FILE
	file_dialog.access = FileDialog.ACCESS_FILESYSTEM
	file_dialog.filters = PackedStringArray(["*.png ; PNG Images", "*.jpg, *.jpeg ; JPG Images"])
	file_dialog.title = "اختر صورة شخصية"
	file_dialog.size = Vector2(600, 400)
	file_dialog.file_selected.connect(func(path):
		var img = Image.load_from_file(path)
		if img: _apply_profile_image(img))
	add_child(file_dialog)

func _on_search_and_add_clicked():
	var search_query = friend_input.text.strip_edges()
	if search_query == "":
		status_label.text = _t("write_name")
		return
	if search_query.to_lower() == my_username.to_lower() or search_query == my_player_id:
		status_label.text = _t("cannot_add_self")
		return
	if my_friends.has(search_query): status_label.text = _t("already_exists") + search_query + "!"
	else:
		my_friends.append(search_query)
		status_label.text = _t("added_success") + search_query + _t("success_end")
		friend_input.text = ""
		_update_friends_ui()

func _on_username_updated(new_name: String):
	var clean_name = new_name.strip_edges()
	if clean_name != "":
		my_username = clean_name
		profile_btn.text = ("" if current_avatar_texture else "👤 ") + my_username

func _update_friends_ui():
	if my_friends.size() == 0: friends_list_label.text = _t("friends_list") + _t("no_friends")
	else:
		var text = _t("friends_list")
		for friend in my_friends: text += "🟢 " + friend + "\n"
		friends_list_label.text = text

func _on_profile_pressed():
	_hide_all_popups()
	profile_popup.visible = true

func _on_add_friend_pressed():
	_hide_all_popups()
	friends_popup.visible = true