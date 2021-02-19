import { useBackend } from '../backend';
import { Button, LabeledList, Section } from '../components';
import { Window } from '../layouts';

export const RIGSuit = (props, context) => {
  const { act, data } = useBackend(context);
  // Extract `health` and `color` variables from the `data` object.
  const {
    cell,
    cellcharge,
  } = data;
  return (
    <Window
      width = {500}
      height = {1000}>
      <Window.Content scrollable>
        <Section title="R.I.G Parameters">
          <LabeledList>
            <LabeledList.Item label="Current cell">
              {cell}
            </LabeledList.Item>
            <LabeledList.Item label="Current cell charge">
              {cellcharge}
            </LabeledList.Item>
            <LabeledList.Item label="Power up">
              <Button
                content="Power the suit"
                onClick={() => act('power')} />
            </LabeledList.Item>
             <LabeledList.Item label="Power down">
              <Button
                content="Unpower the suit"
                onClick={() => act('unpower')} />
             </LabeledList.Item>
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
