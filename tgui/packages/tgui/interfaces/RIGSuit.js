import { useBackend } from '../backend';
import { Button, LabeledList, Section, ProgressBar, Flex} from '../components';
import { Window } from '../layouts';

export const RIGSuit = (props, context) => {
  const { act, data } = useBackend(context);
  // Extract `health` and `color` variables from the `data` object.
  let modules = [
    ...data.module_data,
  ];
  return (
    <Window
      width = {300}
      height = {600}>
      <Window.Content scrollable>
        <Section title="RIG Statistics">
          <LabeledList>
            <Flex>
              <Flex.Item>
                <LabeledList.Item label="Suit status">
                  <Button
                    content={"Debug"}
                    onClick={() => act('power_toggle')} />
                </LabeledList.Item>
              </Flex.Item>
              <Flex.Item>
                <LabeledList.Item label="Current cell charge">
                  {data.cell && (
                    <ProgressBar
                      value={data.percentage / 100}
                      content ={data.charge}
                      ranges={{
                        good: [0.6, Infinity],
                        average: [0.3, 0.6],
                        bad: [-Infinity, 0.3],
                    }}/> ) || 'None'}
                </LabeledList.Item>
              </Flex.Item>
            </Flex>
            <LabeledList.Item label="Current power usage">
              {data.power_use}
            </LabeledList.Item>
            <LabeledList.Item label="Maximum modules count">
              {data.maximum_modules}
            </LabeledList.Item>
            <LabeledList.Item label="Current module weight">
              {data.module_weight}
            </LabeledList.Item>
            <LabeledList.Item label="Maximum module weight">
              {data.maximum_modules_weight}
            </LabeledList.Item>
            <LabeledList.Item label="Current AI">
              {data.ai}
            </LabeledList.Item>
            <Button
              content="Power the suit"
              onClick={() => act('power')} />
            <Button
              content="Unpower the suit"
              onClick={() => act('unpower')} />
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
            {modules.map(module => (
              <LabeledList.Item label={module.name}
                buttons={(
                  <>
                    <Button
                      content="Eject module"
                      onClick={() => act('eject_specific_module', {
                      identifier: module.id,
                    })} />
                    <Button
                      content="Configure"
                      onClick={() => act('configure_specific_module', {
                      identifier: module.id,
                    })} />
                    <Button
                      content="Allow PAI Control"
                      onClick={() => act('give_pai_acces', {
                      identifier: module.id,
                    })} />
                  </>
                )}>
              </LabeledList.Item>
            ))}
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
