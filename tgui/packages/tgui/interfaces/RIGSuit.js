import { useBackend } from '../backend';
import { Button, LabeledList, Section, ProgressBar, Flex, Collapsible} from '../components';
import { LabeledListItem } from '../components/LabeledList';
import { Window } from '../layouts';

export const RIGSuit = (props, context) => {
  const { act, data } = useBackend(context);
  // Extract `health` and `color` variables from the `data` object.
  const {
    chestpiece,
    gloves,
    boots,
    helmet,
    module_data,
    charge,
    module_count,
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
    max_charge,
    armor,
  } = data;
  return (
    <Window
      width = {314}
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
                  width={16}
                  ranges={{
                    good: [0.6, Infinity],
                    average: [0.3, 0.6],
                    bad: [-Infinity, 0.3],
              }}/> ) || 'None'}
            </Flex.Item>
          </Flex>
          <Collapsible
            title = "RIG Information">
              <LabeledList>
                <LabeledListItem label="Module count">
                  {module_count}
                </LabeledListItem>
                <LabeledListItem label="Maximum modules">
                  {maximum_modules}
                </LabeledListItem>
                <LabeledListItem label="Current module weight">
                  {module_weight}
                </LabeledListItem>
                <LabeledListItem label="Maximum module weight">
                  {maximum_modules_weight}
                </LabeledListItem>
                <Collapsible title= "Armor ratings"
                  ml={1.5}>
                  <LabeledListItem label="Melee">
                    <ProgressBar
                      value={armor.melee / 100}
                      content={armor.melee + "%"}
                      width={14}
                      ranges={{
                        good: [0.6, Infinity],
                        average: [0.3, 0.6],
                        bad: [-Infinity, 0.3],
                    }}/>
                  </LabeledListItem>
                  <LabeledListItem label="Bullet">
                    <ProgressBar
                      value={armor.bullet / 100}
                      content={armor.bullet + "%"}
                      width={14}
                      ranges={{
                        good: [0.6, Infinity],
                        average: [0.3, 0.6],
                        bad: [-Infinity, 0.3],
                    }}/>
                  </LabeledListItem>
                  <LabeledListItem label="Laser">
                    <ProgressBar
                      value={armor.laser / 100}
                      content={armor.laser + "%"}
                      width={14}
                      ranges={{
                        good: [0.6, Infinity],
                        average: [0.3, 0.6],
                        bad: [-Infinity, 0.3],
                    }}/>
                  </LabeledListItem>
                  <LabeledListItem label="Energy">
                    <ProgressBar
                      value={armor.energy / 100}
                      content={armor.energy + "%"}
                      width={14}
                      ranges={{
                        good: [0.6, Infinity],
                        average: [0.3, 0.6],
                        bad: [-Infinity, 0.3],
                    }}/>
                  </LabeledListItem>
                  <LabeledListItem label="Bomb">
                    <ProgressBar
                      value={armor.bomb / 100}
                      content={armor.bomb + "%"}
                      width={14}
                      ranges={{
                        good: [0.6, Infinity],
                        average: [0.3, 0.6],
                        bad: [-Infinity, 0.3],
                    }}/>
                  </LabeledListItem>
                  <LabeledListItem label="Bio">
                    <ProgressBar
                      value={armor.bio / 100}
                      content={armor.bio + "%"}
                      width={14}
                      ranges={{
                        good: [0.6, Infinity],
                        average: [0.3, 0.6],
                        bad: [-Infinity, 0.3],
                    }}/>
                  </LabeledListItem>
                  <LabeledListItem label="Radiation">
                    <ProgressBar
                      value={armor.rad / 100}
                      content={armor.rad + "%"}
                      width={14}
                      ranges={{
                        good: [0.6, Infinity],
                        average: [0.3, 0.6],
                        bad: [-Infinity, 0.3],
                    }}/>
                  </LabeledListItem>
                  <LabeledListItem label="Fire">
                    <ProgressBar
                      value={armor.fire/ 100}
                      content={armor.fire + "%"}
                      width={14}
                      ranges={{
                        good: [0.6, Infinity],
                        average: [0.3, 0.6],
                        bad: [-Infinity, 0.3],
                    }}/>
                  </LabeledListItem>
                  <LabeledListItem label="Acid">
                    <ProgressBar
                      value={armor.acid / 100}
                      content={armor.acid + "%"}
                      width={14}
                      ranges={{
                        good: [0.6, Infinity],
                        average: [0.3, 0.6],
                        bad: [-Infinity, 0.3],
                    }}/>
                  </LabeledListItem>
                </Collapsible>
              </LabeledList>
          </Collapsible>
          <Collapsible
            title="RIG Hardware">
              <LabeledList>
                <LabeledListItem label="Helmet">
                  {helmet.name} <br />
                  <Button
                    content={helmet.deployed ? 'Undeploy helmet' : 'Deploy helmet'}
                    color={helmet.deployed ? 'red' : 'blue'}
                    onClick={() => act('toggle_part', {
                    identifier: 1
                    })} />
                </LabeledListItem>
                <LabeledListItem label="Chestpiece">
                  {chestpiece.name} <br />
                  <Button
                    content={chestpiece.deployed ? 'Undeploy chestpiece' : 'Deploy chestpiece'}
                    color={chestpiece.deployed ? 'red' : 'blue'}
                    onClick={() => act('toggle_part', {
                    identifier: 2
                    })} />
                </LabeledListItem>
                <LabeledListItem label="Gloves">
                  {gloves.name} <br />
                  <Button
                    content={gloves.deployed ? 'Undeploy gloves' : 'gloves'}
                    color={gloves.deployed ? 'red' : 'blue'}
                    onClick={() => act('toggle_part', {
                    identifier: 3
                    })} />
                </LabeledListItem>
                <LabeledListItem label="Boots">
                  {boots.name} <br />
                  <Button
                    content={boots.deployed ? 'Undeploy boots' : 'Deploy boots'}
                    color={boots.deployed ? 'red' : 'blue'}
                    onClick={() => act('toggle_part', {
                    identifier: 4
                    })} />
                </LabeledListItem>
                <LabeledListItem label="Cell rating">
                  {max_charge}
                </LabeledListItem>
                <LabeledListItem label="Cell charge">
                  {charge}
                </LabeledListItem>
                <LabeledListItem label="Power usage">
                  {power_use}
                </LabeledListItem>
              </LabeledList>
            </Collapsible>
        <Button
          content={owner ? 'Purge owner' : 'Become owner'}
          onClick={() => act('toggle_owner')}
          color={owner ? 'red' : 'blue'} />
        <Button
          content={id ? 'Purge ID Requirements' : 'Lock RIG to current ID Acces'}
          onClick={() => act('toggle_id')}
          color={id ? 'red' : 'blue'} />
        <Button
          content={lock ? 'Unlock RIG' : 'Lock RIG'}
          onClick={() => act('toggle_lock')}
          color={lock ? 'red' : 'green'}/>
      </Section>
          <Section title="Installed modules">
            {module_data ? module_data.map(module => (
              <Collapsible title={module.name}>
                  <Button
                   content="Eject module"
                   color="red"
                   onClick={() => act('eject_specific_module', {
                   identifier: module.id,
                 })} />
                 <Button
                   content="Configure"
                   onClick={() => act('configure_specific_module', {
                   identifier: module.id,
                 })} />
                 <Button
                   content={module.pai ? 'Disallow PAI Acces' : 'Allow PAI Acces'}
                   color={module.pai ? 'red' : 'blue'}
                   onClick={() => act('give_pai_acces', {
                   identifier: module.id,
                 })} />
              </Collapsible>
             )) : 'None'}
        </Section>
      </Window.Content>
    </Window>
    );
  };
