import { useBackend } from '../backend';
import { Button, LabeledList, Section } from '../components';
import { Window } from '../layouts';

export const RIGModuleTargetedBallistic = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    bullets,
  } = data;
  return (
    <Window resizable
      height = {100}
      >
      <Window.Content scrollable>
        <Section title="Gun configuration">
          <LabeledList>
            <LabeledList.Item label = {"Calibers"}>
              {bullets.map(bullet => (
                <Button
                  color = {bullet.bullet_color}
                  key = {bullet.bullet_caliber}
                  content = {bullet.bullet_caliber + " " + bullet.bullet_count}
                  onClick={() => act('pick', {
                  bulletcaliber: bullet.bullet_caliber
                })} />
              ))}
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
