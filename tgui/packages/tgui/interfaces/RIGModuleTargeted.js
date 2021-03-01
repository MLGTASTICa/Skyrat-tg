import { useBackend } from '../backend';
import { Button, LabeledList, Section } from '../components';
import { LabeledListDivider } from '../components/LabeledList';
import { Window } from '../layouts';

export const RIGModuleTargeted = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    projectiles,
  } = data;
  return (
    <Window
      width = {300}
      height = {600}>
      <Window.Content scrollable>
        <Section title="Module control">
          <LabeledList>
            <LabeledList.Item label="debug">
              {projectiles.map(projectile => (
                <Button
                  key = {projectile.proj_id}
                  content = {projectile.name}
                  onClick={() => act('pick', {
                  identifier: projectile.id,
                })} />
              ))}
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
