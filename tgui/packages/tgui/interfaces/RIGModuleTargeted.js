import { useBackend } from '../backend';
import { Button, LabeledList, Section } from '../components';
import { Window } from '../layouts';

export const RIGModuleTargeted = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    projectiles,
  } = data;
  return (
    <Window resizable
      height = {100}
      >
      <Window.Content scrollable>
        <Section title="Laser lens configurations">
          <LabeledList>
            <LabeledList.Item label = {"Laser type"}>
              {projectiles.map(projectile => (
                <Button
                  key = {projectile.proj_id}
                  content = {projectile.proj_name}
                  onClick={() => act('pick', {
                  identifier: projectile.proj_id,
                  emagged: projectile.proj_emag,
                })} />
              ))}
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
