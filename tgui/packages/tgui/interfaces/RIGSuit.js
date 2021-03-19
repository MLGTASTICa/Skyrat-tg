import { useBackend } from '../backend';
import { Button, LabeledList, Section, ProgressBar, Flex, Collapsible} from '../components';
import { Window } from '../layouts';

export const RIGSuit = (props, context) => {
  const { act, data } = useBackend(context);
  // Extract `health` and `color` variables from the `data` object.
  const {
    module_data,
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
              color={data.powered ? 'red' : 'green'}
              content={data.powered ? 'Unpower' : 'Power'}
              onClick={() => act('power_toggle')} />
              {data.cell && (
                <ProgressBar
                  value={data.percentage / 100}
                  content ={data.percentage + '%'}
                  ranges={{
                    good: [0.6, Infinity],
                    average: [0.3, 0.6],
                    bad: [-Infinity, 0.3],
                }}/> ) || 'None'}
            </Flex>
            <Collapsible
              title = "RIG Information">
              <LabeledList></LabeledList>
              Power usage = {data.power_use} <br/>
              Modules = {data.maximum_modules} <br/>
              Module weight = {data.module_weight} <br/>
              Maximum weight = {data.maximum_modules_weight} <br/>
              Installed AI = {data.ai} <br/>
            </Collapsible>
            <Flex>
             <Flex.item>
              <Button
                content="Become the owner"
                onClick={() => act('toggle_owner')} />
             </Flex.item>
             <Flex.item>
              <Button
                content="Lock to current ID acces"
                onClick={() => act('toggle_id')} />
             </Flex.item>
             <Flex.item>
              <Button
                content="Toggle RIG Lock"
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
    )
  };
