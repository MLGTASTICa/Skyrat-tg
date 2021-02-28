import { useBackend } from '../backend';
import { Button, LabeledList, Section } from '../components';
import { Window } from '../layouts';

export const RIGModuleTargeted = (props, context) => {
  const { act, data } = useBackend(context);
  // Aooeoeoe
  const {
    projectiles = data.projectiles || [],
  } = data;
  return (
    <Window
      width = {300}
      height = {600}>
      <Window.Content scrollable>
        <Section title="Module control">
          <LabeledList>
            <LabeledList.item label="Bruh"
              buttons={(
                <>
                  {projectiles.map(projectile => (
                    <Button
                      content = {projectile.name}
                      onClick={() => act('pick', {
                      identifier: projectile.id,
                    })} />
                  ))}
                </>
              )}>
            </LabeledList.item>
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
