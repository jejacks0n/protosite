export const Logger = {
  error: (message) => {
    Logger.log(message, {style: 'color: #f00'})
  },

  log: (message, options = {}) => {
    console.log(`%cProto%csite%c: %c${message}`, 'background:#ddd;color:#000', 'background:#000;color:#fff', '', options.style || '')
  }
}
