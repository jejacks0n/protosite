const styles = ['background:#ddd;color:#000', 'background:#000;color:#fff']

export const Logger = {
  log: (...messages) => {
    let last = messages[messages.length - 1]
    const opts = last && last.status ? messages.pop() : {}
    Logger.output(messages, opts)
  },

  output: (messages, options = {}) => {
    if (options.status === 'error') options['style'] = 'color: #f00'

    if (Array.isArray(messages) && messages.length > 1) {
      console.log(`%cProto%csite%c:`, ...styles, options.style || '', ...messages)
    } else {
      console.log(`%cProto%csite%c: %c${messages.join(' ')}`, ...styles, '', options.style || '')
    }
  }
}
