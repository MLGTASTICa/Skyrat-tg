import { useBackend } from '../backend';
import { Button, LabeledList, Section, ProgressBar, Flex, Collapsible} from '../components';
import { Window } from '../layouts';

export const RIGSuit = (props, context) => {
  const { act, data } = useBackend(context);
  // Extract `health` and `color` variables from the `data` object.
  const {
    module_data,
    percentage,
    powered,
    power_use,
    maximum_modules,
    module_weight,
    maximum_modules_weight,
    cell,
    owner,
    lock,
    id,
  } = data;
  return (
    <Window
      width = {300}
      height = {600}>
      <Window.Content scrollable>
        <Section title="RIG Statistics">
          <Flex>
            <Button
              icon="power-off"
              color={powered ? 'red' : 'green'}
              content={powered ? 'Unpower' : 'Power'}
              onClick={() => act('power_toggle')} />
              {cell && (
                <ProgressBar
                  value={percentage / 100}
                  content ={percentage + '%'}
                  ranges={{
                    good: [0.6, Infinity],
                    average: [0.3, 0.6],
                    bad: [-Infinity, 0.3],
                }}/> ) || 'None'}
            </Flex>
            <Collapsible
              title = "RIG Information">
              <LabeledList>
                <LabeledList.Item>
                  Power usage = {power_use}
                </LabeledList.Item>
                <LabeledList.Item>
                  Modules = {maximum_modules}
                </LabeledList.Item>
                <LabeledList.Item>
                  Module weight = {module_weight}
                </LabeledList.Item>
                <LabeledList.Item>
                  Maximum weight = {maximum_modules_weight}
                </LabeledList.Item>
              </LabeledList>
            </Collapsible>
            <Flex>
             <Flex.item>
              <Button
                content={owner ? 'Purge owner' : 'Become owner'}
                onClick={() => act('toggle_owner')} />
             </Flex.item>
             <Flex.item>
              <Button
                content={id ? 'Purge ID Requirements' : 'Lock RIG to current ID Acces'}
                onClick={() => act('toggle_id')} />
             </Flex.item>
             <Flex.item>
              <Button
                content={lock ? 'Unlock RIG' : 'Lock RIG'}
                onClick={() => act('toggle_lock')} />
             </Flex.item>
            </Flex>
          </Section>
          <LabeledList>
          <Section title="Modules?">
            {module_data ? module_data.map(module => (
              <Flex>
                <Flex.item>
                 <Button
                   content="Eject module"
                   onClick={() => act('eject_specific_module', {
                   identifier: module.id,
                 })} />
                </Flex.item>
                <Flex.item>
                 <Button
                   content="Configure"
                   onClick={() => act('configure_specific_module', {
                   identifier: module.id,
                 })} />
                </Flex.item>
                <Flex.item>
                 <Button
                   content="Allow PAI Control"
                   onClick={() => act('give_pai_acces', {
                   identifier: module.id,
                 })} />
                </Flex.item>
              </Flex>
             )) : 'None'}
          </Section>
          </LabeledList>
      </Window.Content>
    </Window>
    );
  };
