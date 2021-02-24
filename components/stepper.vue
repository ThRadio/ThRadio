<template>
  <div class="StepperComponent">
    <!-- Mobile and tablet -->
    <v-stepper v-model="step" class="hidden-md-and-up" vertical>
      <slot name="title"></slot>
      <v-divider></v-divider>

      <template v-for="n in steps">
        <slot :name="`step-${n}`"> </slot>
        <slot :name="`content-${n}`"> </slot>
      </template>
    </v-stepper>

    <!-- Desktop -->
    <v-stepper v-model="step" alt-labels class="hidden-sm-and-down">
      <slot name="title"></slot>
      <v-divider></v-divider>

      <v-stepper-header class="text-center">
        <template v-for="n in steps">
          <slot :name="`step-${n}`"> </slot>
          <v-divider v-if="n != steps" :key="'ls-step-' + n"></v-divider>
        </template>
      </v-stepper-header>

      <v-stepper-items>
        <slot v-for="n in steps" :name="`content-${n}`"> </slot>
      </v-stepper-items>
    </v-stepper>
  </div>
</template>

<script lang="ts">
import { Component, Vue, Prop, VModel } from 'nuxt-property-decorator'

@Component
export default class StepperComponent extends Vue {
  @VModel({ type: Number }) step!: number
  @Prop(Number) readonly steps: number | undefined
}
</script>
