import { useBackend } from '../backend';
import { Button, LabeledList, Section } from '../components';
import { Window } from '../layouts';

export const RIGSuit = (props, context) => {
  const { act, data } = useBackend(context);
  // Extract `health` and `color` variables from the `data` object.
  const {
    cell,
    cellcharge,
    power_use,
    module_count,
    maximum_modules,
    maximum_modules_weight,
    module_weight,
    ai,
  } = data;
  return (
    <Window
      width = {500}
      height = {500}>
      <Window.Content scrollable>
        <Section title="RIG Statistics">
          <LabeledList>
            <LabeledList.Item label="Current cell">
              {cell}
            </LabeledList.Item>
            <LabeledList.Item label="Current cell charge">
              {cellcharge}
            </LabeledList.Item>
            <LabeledList.Item label="Current power usage">
              {power_use}
            </LabeledList.Item>
            <LabeledList.Item label="Installed modules count">
              {module_count}
            </LabeledList.Item>
            <LabeledList.Item label="Maximum modules count">
              {maximum_modules}
            </LabeledList.Item>
            <LabeledList.Item label="Current module weight">
              {module_weight}
            </LabeledList.Item>
            <LabeledList.Item label="Maximum module weight">
              {maximum_modules_weight}
            </LabeledList.Item>
            <LabeledList.Item label="Current AI">
              {ai}
            </LabeledList.Item>
            <Button
              content="Power the suit"
              onClick={() => act('power')} />
            <Button
              content="Unpower the suit"
              onClick={() => act('unpower')} />
            <Button
              content="Eject a module"
              onClick={() => act('eject_module')} />
            <Button
              content="Become the owner"
              onClick={() => act('become_owner')} />
            <Button
              content="Purge current owner"
              onClick={() => act('remove_owner')} />
            <Button
              content="Lock to current ID acces"
              onClick={() => act('lock_to_id')} />
            <Button
              content="Purge ID requirements"
              onClick={() => act('purge_acces')} />
             <Button
              content="Toggle RIG Lock"
              onClick={() => act('toggle_lock')} />
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
