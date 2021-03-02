import { useBackend } from '../backend';
import { Button, LabeledList, Section } from '../components';
import { Window } from '../layouts';

export const RIGModuleReagent = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    reagents,
  } = data;
  return (
    <Window resizable
      height = {100}
      >
      <Window.Content scrollable>
        <Section title="Available Beakers">
          <LabeledList>
            <LabeledList.Item label = {"Selected Beaker"}>
              {reagents.map(reagent => (
                <Button
                  color = {reagent.reg_color}
                  key = {reagent.reg_id}
                  content = {reagent.reg_name}
                  onClick={() => act('pick', {
                  identifier: reagent.reg_id,
                })} />
              ))}
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
