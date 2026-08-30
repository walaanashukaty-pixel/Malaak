from pathlib import Path
import re
root=Path(__file__).resolve().parents[1]
home=(root/'lib/screens/home/home_screen.dart').read_text(encoding='utf-8')
journey=(root/'lib/screens/journey/journey_screen.dart').read_text(encoding='utf-8')
for text,name in [(home,'home'),(journey,'journey')]:
    assert 'journeyPlan' in text, f'{name} does not consume real journeyPlan'
    assert not re.search(r'\b\d{1,3}\s*%', text), f'fake percentage found in {name}'
assert 'المسار الأساسي' in home and 'المسار المساند' in home
for label in ['المسار الأساسي','مسار مساند','مراقبة','لاحقًا']:
    assert label in journey, f'missing journey planner label {label}'
assert 'plan.isPaused' in home or 'isPaused' in home, 'Home missing paused/safety plan handling'
assert 'plan.isPaused' in journey or 'isPaused' in journey, 'Journey missing paused/safety plan handling'
assert "AppCatalog.journeyById('attachment')" not in journey, 'Journey still hardcodes attachment as current plan'
print('PASS V5C planner UI structure')
