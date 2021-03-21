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
      width = {50}
      height = {600}>
      <Window.Content scrollable>
        <Section title="RIG Statistics">
          <Flex>
            <Flex.Item>
              <Button
                icon="power-off"
                color={powered ? 'red' : 'green'}
                content={powered ? 'Unpower' : 'Power'}
                onClick={() => act('power_toggle')} />
            </Flex.Item>
            <Flex.Item>
              {cell && (
                <ProgressBar
                  value={percentage / 100}
                  content={percentage + '%'}
                  ranges={{
                    good: [0.6, Infinity],
                    average: [0.3, 0.6],
                    bad: [-Infinity, 0.3],
              }}/> ) || 'None'}
          </Flex.Item>
          </Flex>
          <Collapsible
            title = "RIG Information">
              Bruh momento ?
          </Collapsible>
        <Button
          content={owner ? 'Purge owner' : 'Become owner'}
          onClick={() => act('toggle_owner')} />
        <Button
          content={id ? 'Purge ID Requirements' : 'Lock RIG to current ID Acces'}
          onClick={() => act('toggle_id')} />
        <Button
          content={lock ? 'Unlock RIG' : 'Lock RIG'}
          onClick={() => act('toggle_lock')} />
        </Section>
          <LabeledList>
          <Section title="Modules?">
            {module_data ? module_data.map(module => (
              <Flex>
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
              </Flex>
             )) : 'None'}
          </Section>
          </LabeledList>
      </Window.Content>
    </Window>
    );
  };
