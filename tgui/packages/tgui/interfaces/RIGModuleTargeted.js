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
    <Window>
      <Window.Content scrollable>
        <Section title="Module configuration">
          <LabeledList>
            <LabeledList.Item>
              {projectiles.map(projectile => (
                <Button
                  key = {projectile.proj_id}
                  content = {projectile.proj_name}
                  onClick={() => act('pick', {
                  identifier: projectile.proj_id,
                })} />
              ))}
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
